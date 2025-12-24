package com.zyd.blog.persistence.mapper;

import com.zyd.blog.business.entity.UserFollow;
import com.zyd.blog.persistence.beans.BizUserFollow;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BizUserFollowMapper {

    int insert(@Param("followerId") Long followerId,
               @Param("followedId") Long followedId);

    int delete(@Param("followerId") Long followerId,
               @Param("followedId") Long followedId);

    int countByFollowerAndFollowed(@Param("followerId") Long followerId,
                                   @Param("followedId") Long followedId);

    int countFollowers(@Param("userId") Long userId);

    int countFollowing(@Param("userId") Long userId);

    List<BizUserFollow> listFollower(@Param("userId") Long userId);

    List<BizUserFollow> listFollowing(@Param("userId") Long userId);
}
