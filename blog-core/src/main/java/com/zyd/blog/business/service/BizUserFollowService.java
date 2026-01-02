package com.zyd.blog.business.service;

import com.github.pagehelper.PageInfo;
import com.zyd.blog.business.entity.User;
import com.zyd.blog.business.entity.UserFollow;
import com.zyd.blog.persistence.beans.BizUserFollow;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BizUserFollowService {

    /**
     * 关注
     */
    boolean follow(Long followerId, Long followedUserId);

    /**
     * 取消关注
     */
    boolean unfollow(Long followerId, Long followedUserId);

    /**
     * 是否已关注
     */
    boolean isFollowed(Long followerId, Long followedId);

    int countFollowers(Long userId);

    int countFollowing( Long userId);
    /**
     * 我的关注列表
     */
    List<BizUserFollow>  listMyFollowing(Long userId);

    /**
     * 我的粉丝列表
     */
    List<BizUserFollow>  listMyFollowers(Long userId);
}

