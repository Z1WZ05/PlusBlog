package com.zyd.blog.business.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.zyd.blog.persistence.beans.BizUserFollow;

import java.util.Date;

/**
 * 用户关注关系 VO
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class UserFollow {

    private final BizUserFollow bizUserFollow;

    public UserFollow() {
        this.bizUserFollow = new BizUserFollow();
    }

    public UserFollow(BizUserFollow bizUserFollow) {
        this.bizUserFollow = bizUserFollow;
    }

    /* ================== 原始 DO ================== */

    @JsonIgnore
    public BizUserFollow getBizUserFollow() {
        return bizUserFollow;
    }

    /* ================== 基础字段代理 ================== */

    public Long getId() {
        return bizUserFollow.getId();
    }

    public void setId(Long id) {
        bizUserFollow.setId(id);
    }

    public Long getFollowerId() {
        return bizUserFollow.getFollowerId();
    }

    public void setFollowerId(Long followerId) {
        bizUserFollow.setFollowerId(followerId);
    }

    public Long getFollowedId() {
        return bizUserFollow.getFollowedId();
    }

    public void setFollowedId(Long followedId) {
        bizUserFollow.setFollowedId(followedId);
    }

    public Date getCreateTime() {
        return bizUserFollow.getCreateTime();
    }
    public void setCreateTime(Date createTime) {
        bizUserFollow.setCreateTime(createTime);
    }

    /* ================== 关联对象 ================== */

    public User getFollower() {
        return bizUserFollow.getFollower() == null
                ? null
                : new User(bizUserFollow.getFollower());
    }

    public void setFollower(User user) {
        bizUserFollow.setFollower(user == null ? null : user.getSysUser());
    }

    public User getFollowed() {
        return bizUserFollow.getFollowed() == null
                ? null
                : new User(bizUserFollow.getFollowed());
    }

    public void setFollowed(User user) {
        bizUserFollow.setFollowed(user == null ? null : user.getSysUser());
    }

    /* ================== 业务辅助方法 ================== */

    /**
     * 是否是某个用户关注的
     */
    public boolean isFollowedBy(Long userId) {
        return userId != null && userId.equals(getFollowerId());
    }
}

