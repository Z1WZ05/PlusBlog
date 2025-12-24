package com.zyd.blog.business.service.impl;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zyd.blog.business.entity.User;
import com.zyd.blog.business.entity.UserFollow;
import com.zyd.blog.business.service.BizUserFollowService;
import com.zyd.blog.persistence.beans.BizUserFollow;
import com.zyd.blog.persistence.mapper.BizUserFollowMapper;
import com.zyd.blog.util.SessionUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Slf4j
@Service
public class BizUserFollowServiceImpl implements BizUserFollowService {

    @Autowired
    private BizUserFollowMapper bizUserFollowMapper;

    /**
     * 关注
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean follow(Long followerId, Long followedUserId) {

        return bizUserFollowMapper.insert(followerId,followedUserId) > 0;
    }

    /**
     * 取消关注
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean unfollow(Long followerId, Long followedUserId) {

        return bizUserFollowMapper.delete(followerId, followedUserId) > 0;
    }

    /**
     * 是否已关注
     */
    @Override
    public boolean isFollowed(Long followerId, Long followedId) {
        return bizUserFollowMapper.countByFollowerAndFollowed(
                followerId, followedId
        ) > 0;
    }

    /**
     * 我的关注
     */
    @Override
    public PageInfo<UserFollow> listMyFollowing(Long userId, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);

        List<BizUserFollow> list = bizUserFollowMapper.listFollowing(userId);
        return wrapPage(list);
    }

    /**
     * 我的粉丝
     */
    @Override
    public PageInfo<UserFollow> listMyFollowers(Long userId, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);

        List<BizUserFollow> list = bizUserFollowMapper.listFollower(userId);
        return wrapPage(list);
    }
    public int countFollowers(Long userId){
        int count = bizUserFollowMapper.countFollowers(userId);
        return count;
    }

    public int countFollowing(@Param("userId") Long userId){
        int count = bizUserFollowMapper.countFollowing(userId);
        return count;
    }

    /**
     * 统一包装（和 Article 一样）
     */
    private PageInfo<UserFollow> wrapPage(List<BizUserFollow> list) {
        if (CollectionUtils.isEmpty(list)) {
            return new PageInfo<>(Collections.emptyList());
        }

        List<UserFollow> result = new ArrayList<>();
        for (BizUserFollow entity : list) {
            result.add(new UserFollow(entity));
        }

        PageInfo page = new PageInfo<>(list);
        page.setList(result);
        return page;
    }
}
