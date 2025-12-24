package com.zyd.blog.persistence.beans;

import com.zyd.blog.framework.object.AbstractDO;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.persistence.Transient;

/**
 * 用户关注关系 DO
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class BizUserFollow extends AbstractDO {

    /** 关注者 ID */
    private Long followerId;

    /** 被关注者 ID */
    private Long followedId;

    /* ================== 非数据库字段 ================== */

    /** 关注者对象 */
    @Transient
    private SysUser follower;

    /** 被关注者对象 */
    @Transient
    private SysUser followed;
}
