package com.zyd.blog.controller;

import com.zyd.blog.business.entity.Article;
import com.zyd.blog.business.entity.User;
import com.zyd.blog.business.entity.Tags;
import com.zyd.blog.business.entity.Type;
import com.zyd.blog.persistence.beans.BizArticle;
import com.zyd.blog.business.entity.ArticleTags; // 引入关联表实体
import com.zyd.blog.business.service.BizArticleService;
import com.zyd.blog.business.service.BizTypeService;
import com.zyd.blog.business.service.BizTagsService;
import com.zyd.blog.business.service.BizArticleTagsService; // 引入关联表Service
import com.zyd.blog.persistence.mapper.BizArticleMapper;
import com.zyd.blog.util.ResultUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/user/article")
public class UserArticleController {

    @Autowired
    private BizArticleService articleService;
    @Autowired
    private BizTypeService typeService;
    @Autowired
    private BizTagsService tagsService;
    @Autowired
    private BizArticleMapper articleMapper;

    // 👇 新增：注入文章-标签关联 Service
    @Autowired
    private BizArticleTagsService articleTagsService;

    @GetMapping("/write")
    public String writePage(@RequestParam(value = "id", required = false) Long id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        model.addAttribute("types", typeService.listAll());
        model.addAttribute("tags", tagsService.listAll());

        if (id != null) {
            BizArticle bizArticle = articleMapper.selectByPrimaryKey(id);
            if (bizArticle != null && user.getId().equals(bizArticle.getUserId())) {
                Article article = new Article(bizArticle);
                model.addAttribute("article", article);
            }
        }
        return "user/editor";
    }

    @PostMapping("/save")
    @ResponseBody
    public Object save(Article article, Integer type, Long[] tagIds, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResultUtil.error("登录超时");

        try {
            article.setUserId(user.getId());
            article.setStatus(type);
            article.setUpdateTime(new Date());

            // 1. 兜底分类
            if (article.getTypeId() == null) {
                List<Type> typeList = typeService.listAll();
                if (typeList != null && !typeList.isEmpty()) {
                    article.setTypeId(typeList.get(0).getId());
                } else {
                    article.setTypeId(1L);
                }
            }

            // 2. 处理 Keywords (仅用于显示)
            if (tagIds != null && tagIds.length > 0) {
                List<Tags> allTags = tagsService.listAll();
                StringBuilder keywords = new StringBuilder();
                for (Long tid : tagIds) {
                    for (Tags t : allTags) {
                        if (t.getId().equals(tid)) {
                            keywords.append(t.getName()).append(",");
                            break;
                        }
                    }
                }
                if (keywords.length() > 0) {
                    article.setKeywords(keywords.substring(0, keywords.length() - 1));
                }
            }

            // 3. 保存文章主表
            if (article.getId() == null) {
                article.setCreateTime(new Date());
                article.setLookCount(0);
                article.setCommentCount(0);
                article.setLoveCount(0);
                if (article.getCoverImage() == null || article.getCoverImage().isEmpty()) {
                    article.setCoverImage("/assets/img/default-cover.jpg");
                }
                articleService.insert(article);
            } else {
                BizArticle oldBizArticle = articleMapper.selectByPrimaryKey(article.getId());
                if (oldBizArticle != null && user.getId().equals(oldBizArticle.getUserId())) {
                    article.setLookCount(oldBizArticle.getLookCount());
                    article.setCommentCount(oldBizArticle.getCommentCount());
                    article.setLoveCount(oldBizArticle.getLoveCount());
                    article.setCreateTime(oldBizArticle.getCreateTime());
                    articleService.updateSelective(article);
                } else {
                    return ResultUtil.error("无权修改");
                }
            }

            // 4. 【核心修复】：保存文章-标签关联数据
            // 这里的 article.getId() 在 insert 执行后会自动被赋值（MyBatis 主键回填）
            if (tagIds != null && tagIds.length > 0 && article.getId() != null) {
                updateArticleTags(article.getId(), tagIds);
            }

            return ResultUtil.success(type == 1 ? "发布成功！" : "已存入草稿箱");
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error("操作失败：" + e.getMessage());
        }
    }

    // 辅助方法：更新标签关联
    private void updateArticleTags(Long articleId, Long[] tagIds) {
        // 1. 先删除旧关联
        // 修正点：直接传入 Long 类型的 articleId
        articleTagsService.removeByArticleId(articleId);

        // 2. 循环插入新关联
        if (tagIds != null && tagIds.length > 0) {
            for (Long tagId : tagIds) {
                // 修正点：实例化 ArticleTags (包装类)，而不是 BizArticleTags
                ArticleTags tagRel = new ArticleTags();
                tagRel.setArticleId(articleId);
                tagRel.setTagId(tagId);
                tagRel.setCreateTime(new Date());
                tagRel.setUpdateTime(new Date());

                // 现在类型匹配了，可以插入了
                articleTagsService.insert(tagRel);
            }
        }
    }

    /**
     * 3. 快速发布草稿
     */
    @PostMapping("/publish")
    @ResponseBody
    public Object publish(Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");

        // 【核心修改】：使用 mapper 查数据
        BizArticle bizArticle = articleMapper.selectByPrimaryKey(id);

        if (bizArticle == null || !user.getId().equals(bizArticle.getUserId())) {
            return ResultUtil.error("权限不足或文章不存在");
        }

        Article article = new Article(bizArticle);
        article.setStatus(1);
        article.setUpdateTime(new Date());

        articleService.updateSelective(article);

        return ResultUtil.success("发布成功！");
    }

    /**
     * 4. 删除文章
     */
    @PostMapping("/delete")
    @ResponseBody
    public Object delete(Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");

        // 【核心修改】：使用 mapper 查数据
        BizArticle bizArticle = articleMapper.selectByPrimaryKey(id);

        if (bizArticle != null && user.getId().equals(bizArticle.getUserId())) {
            articleService.removeByPrimaryKey(id);
            return ResultUtil.success("删除成功");
        }

        return ResultUtil.error("删除失败");
    }
}