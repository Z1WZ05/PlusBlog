package com.zyd.blog.controller;
// ↑↑↑ 注意：如果你的文件夹路径确实是 com.zhb，请把上面这行改为 package com.zhb.blog.controller;

import com.github.pagehelper.PageInfo;
// 1. 修正实体类引用 (根据你的要求，使用 User 和 Article)
import com.zyd.blog.business.entity.Article;
import com.zyd.blog.business.entity.User;
// 2. 修正 Service 引用 (根据你的要求，使用 SysUserService 和 BizArticleService)
import com.zyd.blog.business.service.BizArticleService;
import com.zyd.blog.business.service.BizUserFollowService;
import com.zyd.blog.business.service.SysUserService;
// 3. 结果返回工具 (尝试引用 ResponseVO，如果爆红请看代码末尾的注释)
import com.zyd.blog.business.vo.ArticleConditionVO;
import com.zyd.blog.util.ResultUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserCenterController {

    @Autowired
    private SysUserService userService;     // Service 是 SysUserService

    @Autowired
    private BizArticleService articleService; // Service 是 BizArticleService

    @Autowired
    private BizUserFollowService userFollowService;

    /**
     * 1. 个人中心页面
     */
    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        // 从 Session 获取当前登录用户 (强制转换为 User)
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            return "redirect:/login";
        }
        int followerCount = userFollowService.countFollowers(currentUser.getId());
        int followingCount = userFollowService.countFollowing(currentUser.getId());


        // 重新查询用户信息
        // 方法名推测：标准 MyBatis 生成的方法通常叫 selectByPrimaryKey
        User user = userService.getByPrimaryKey(currentUser.getId());
        model.addAttribute("user", user);

        // 获取文章列表
        Article condition = new Article();
        condition.setUserId(user.getId());

        List<Article> myArticles = articleService.listByUserId(user.getId());

        PageInfo<Article> pageInfo = new PageInfo<>(myArticles);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("isSelf", true);
        model.addAttribute("followerCount", followerCount);
        model.addAttribute("followingCount", followingCount);
        return "user/profile";
    }

    /**
     * 2. 修改个人信息接口
     */
    @PostMapping("/saveProfile")
    @ResponseBody
    public Object saveProfile(User userForm, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return ResultUtil.error("请先登录");
        }

        // 查旧数据
        User userToUpdate = userService.getByPrimaryKey(currentUser.getId());

        // 更新字段
        userToUpdate.setNickname(userForm.getNickname());
        userToUpdate.setAvatar(userForm.getAvatar());
        userToUpdate.setRemark(userForm.getRemark());
        userToUpdate.setEmail(userForm.getEmail());
        userToUpdate.setUpdateTime(new Date());
        userToUpdate.setPassword(null);

        // 执行更新 (标准 MyBatis 方法)
        userService.updateSelective(userToUpdate);

        // 更新 Session
        User refreshedUser = userService.getByPrimaryKey(currentUser.getId());
        session.setAttribute("user", refreshedUser);

        return ResultUtil.success("修改成功");
    }

    /**
     * 3. 头像上传
     */
    @PostMapping("/upload")
    @ResponseBody
    public Object upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ResultUtil.error("文件为空");
        }
        try {
            String fileName = file.getOriginalFilename();
            String suffixName = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID() + suffixName;

            // 【路径修复】：兼容 Windows 和 Linux，确保路径分隔符正确
            // 获取项目编译后的 static/upload 目录
            String projectPath = System.getProperty("user.dir");
            String uploadDir = projectPath + "/blog-web/target/classes/static/upload/";

            // 如果是 Windows，System.getProperty 可能返回反斜杠，处理一下
            File destDir = new File(uploadDir);
            if (!destDir.exists()) {
                destDir.mkdirs();
            }

            File dest = new File(destDir, newFileName);
            file.transferTo(dest);

            // 返回给前端的必须是 Web 路径 (正斜杠)
            String fileUrl = "/upload/" + newFileName;

            return ResultUtil.success("上传成功", fileUrl);
        } catch (IOException e) {
            e.printStackTrace();
            return ResultUtil.error("上传失败: " + e.getMessage());
        }
    }

    @GetMapping("/{userId}")
    public String userHome(
            @PathVariable Long userId,
            Model model,
            HttpSession session,
            @RequestParam(defaultValue = "1") int pageNum
    ) {
        User user = userService.getByPrimaryKey(userId);
        if (user == null) {
            return "error/404";
        }

        List<Article> myArticles = articleService.listByUserId(user.getId());
        PageInfo<Article> pageInfo = new PageInfo<>(myArticles);
        model.addAttribute("user", user);
        model.addAttribute("pageInfo", pageInfo);
        int followerCount = userFollowService.countFollowers(userId);
        int followingCount = userFollowService.countFollowing(userId);
        model.addAttribute("followerCount", followerCount);
        model.addAttribute("followingCount", followingCount);
        User currentUser = (User) session.getAttribute("user");
        boolean followed = false;
        if (currentUser != null) {
            followed = userFollowService.isFollowed(currentUser.getId(), userId);
        }
        model.addAttribute("hostUserId", userId);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("followed", followed);
        model.addAttribute("isSelf",
                currentUser != null && currentUser.getId().equals(userId));

        return "user/profile";
    }

    @RestController
    @RequestMapping("/follow")
    public class FollowController {

        @Autowired
        private BizUserFollowService followService;

        @PostMapping("/add")
        public ResponseEntity<?> follow(Long authorId, HttpSession session) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return ResponseEntity.status(401).build();
            }
            followService.follow(user.getId(), authorId);
            return ResponseEntity.ok().build();
        }

        @PostMapping("/remove")
        public ResponseEntity<?> unfollow(Long authorId, HttpSession session) {
            User user = (User) session.getAttribute("user");
            if (user == null) {
                return ResponseEntity.status(401).build();
            }
            followService.unfollow(user.getId(), authorId);
            return ResponseEntity.ok().build();
        }
    }


}