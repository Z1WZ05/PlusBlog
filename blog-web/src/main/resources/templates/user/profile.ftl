<#include "/include/macros.ftl">
<@header title="关于 | ${config.siteName}" description="关于${config.siteName}" canonical="/about"></@header>


<div class="container main-container">
    <div class="row">
        <!-- 左侧：个人概览 -->
        <div class="col-md-3">
            <div class="box-card">
                <div class="user-cover"></div>
                <div class="box-body user-info-inner">
                    <!-- 头像区域 -->
                    <div class="avatar-wrapper" onclick="$('#fileInput').click()">
                        <img id="avatarImg" src="${(user.avatar)!('/assets/img/default-avatar.png')}" class="user-avatar">
                        <#if isSelf>
                        <div class="avatar-mask"><i class="fa fa-camera"></i> 更换</div>
                        </#if>
                    </div>
                    <p>
                        关注：${followingCount}
                        |
                        粉丝：${followerCount}
                    </p>
                    <#-- 已登录 && 不是本人 才显示关注按钮 -->
                    <#if currentUser?? && !isSelf>

                        <button id="follow-btn" class="btn btn-primary" data-followed="${followed?string('1','0')}" ONCLICK="subscribe(${hostUserId})">
                            <#if followed>
                                已关注
                            <#else>
                                关注
                            </#if>

                        </button>

                    </#if>

                    <!-- 隐藏的文件上传框 -->
                    <#if isSelf>
                    <input type="file" id="fileInput" style="display: none;" onchange="uploadAvatar()">
                    </#if>
                    <div class="user-name">${user.nickname!'测试用户'}</div>
                    <div class="user-bio">${(user.remark)!('这个人很懒，什么都没写')}</div>

                    <div style="margin-top: 20px;">
                        <div class="row">
                            <div class="col-xs-6" style="border-right: 1px solid #eee;">
                                <strong>${(pageInfo.list?size)!0}</strong><br><span class="text-muted small">文章</span>
                            </div>
                            <div class="col-xs-6">
                                <strong>0</strong><br><span class="text-muted small">获赞</span>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- 右侧：详细内容 -->
        <div class="col-md-9">
            <!-- 个人资料卡片 -->
            <div class="box-card">
                <div class="box-header">
                    <i class="fa fa-id-card-o"></i> 个人资料
                    <#if isSelf>
                        <!-- 切换按钮：仅控制文本资料的修改 -->
                    <button class="btn btn-primary btn-xs pull-right" id="btnEdit" onclick="switchMode('edit')">
                        <i class="fa fa-pencil"></i> 修改资料
                    </button>
                    <button class="btn btn-default btn-xs pull-right" id="btnCancel" onclick="switchMode('view')" style="display: none;">
                        <i class="fa fa-undo"></i> 取消修改
                    </button>
                    </#if>

                </div>
                <div class="box-body">

                    <!-- 模式1：查看模式 (默认显示) -->
                    <div id="viewPanel">
                        <div class="profile-view-item">
                            <span class="view-label"><i class="fa fa-user-o"></i> 昵称</span>
                            <span class="view-value">${user.nickname!'未设置'}</span>
                        </div>
                        <div class="profile-view-item">
                            <span class="view-label"><i class="fa fa-envelope-o"></i> 邮箱</span>
                            <span class="view-value">${user.email!'未绑定'}</span>
                        </div>
                        <div class="profile-view-item">
                            <span class="view-label"><i class="fa fa-file-text-o"></i> 简介</span>
                            <span class="view-value">${(user.remark)!('暂无简介')}</span>
                        </div>
                        <div class="profile-view-item">
                            <span class="view-label"><i class="fa fa-clock-o"></i> 注册时间</span>
                            <span class="view-value">${(user.createTime?string('yyyy-MM-dd'))!}</span>
                        </div>
                    </div>

                    <!-- 模式2：编辑模式 (默认隐藏) -->
                    <form id="editPanel" style="display: none;" class="form-horizontal">
                        <!-- 隐藏域：头像路径 -->
                        <input type="hidden" name="avatar" id="avatarPath" value="${user.avatar!}">

                        <div class="form-group">
                            <label class="col-sm-2 control-label">昵称</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" name="nickname" value="${user.nickname!}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-9">
                                <input type="email" class="form-control" name="email" value="${user.email!}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">个人简介</label>
                            <div class="col-sm-9">
                                <textarea class="form-control" name="remark" rows="4">${user.remark!}</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                <!-- 这里的保存按钮只负责保存文本信息的修改 -->
                                <button type="button" class="btn btn-primary" onclick="saveData(false)">保存修改</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 我的文章板块 -->
            <div class="box-card">
                <div class="box-header">
                    <i class="fa fa-book"></i> 发表文章
                    <#if isSelf>
                        <!-- 写文章入口 -->
                        <a href="/user/article/write" class="btn btn-success btn-xs pull-right">
                            <i class="fa fa-plus"></i> 写文章
                        </a>
                    </#if>
                </div>
                <div class="box-body" style="padding: 0 20px;">
                    <#if pageInfo?? && pageInfo.list?? && pageInfo.list?size gt 0>
                        <#list pageInfo.list as item>
                            <div class="article-item">
                                <!-- 文章标题 -->
                                <a href="/article/${item.id?c}" target="_blank" class="article-title">${item.title!}</a>

                                <div class="article-meta">
                                    <span style="margin-right: 15px;"><i class="fa fa-calendar"></i> ${item.createTime?string('yyyy-MM-dd HH:mm')}</span>
                                    <span style="margin-right: 15px;"><i class="fa fa-eye"></i> ${item.lookCount} 阅读</span>
                                    <!-- 状态标签 -->
                                    <#if item.status == 1>
                                        <span class="status-badge status-success">已发布</span>
                                    <#else>
                                        <span class="status-badge status-draft">草稿</span>
                                    </#if>
                                </div>
                                <#if isSelf>
                                <!-- 操作按钮组 (右浮动) -->
                                <div class="article-actions">
                                    <#if item.status == 0>
                                        <!-- 草稿状态：显示编辑和发布 -->
                                        <a href="/user/article/write?id=${item.id?c}" class="btn btn-xs btn-info" title="编辑"><i class="fa fa-edit"></i> 编辑</a>
                                        <button class="btn btn-xs btn-primary" onclick="quickPublish(${item.id?c})" title="快速发布"><i class="fa fa-rocket"></i> 发布</button>
                                    </#if>
                                    <!-- 所有状态都可以删除 -->
                                    <button class="btn btn-xs btn-danger" onclick="deleteArticle(${item.id?c})" title="删除"><i class="fa fa-trash"></i></button>
                                </div>
                                </#if>
                            </div>
                        </#list>
                    <#else>
                        <div style="text-align: center; padding: 40px; color: #999;">
                            <i class="fa fa-file-text-o fa-2x"></i>
                            <p style="margin-top: 10px;">暂无发布的文章</p>
                        </div>
                    </#if>
                </div>
            </div>
        </div>
    </div>
</div>

    <@footer></@footer>

<!-- JS -->


<script>
    // 切换 查看/编辑 模式
    function switchMode(mode) {
        if (mode === 'edit') {
            $('#viewPanel').hide();
            $('#editPanel').fadeIn();
            $('#btnEdit').hide();
            $('#btnCancel').show();
        } else {
            $('#editPanel').hide();
            $('#viewPanel').fadeIn();
            $('#btnEdit').show();
            $('#btnCancel').hide();
        }
    }

    // 上传头像 (上传成功后自动静默保存)
    function uploadAvatar() {
        var fileInput = $("#fileInput")[0];
        if(fileInput.files.length === 0) return;
        var file = fileInput.files[0];
        var formData = new FormData();
        formData.append("file", file);

        var loading = layer.load(1);
        $.ajax({
            url: '/user/upload',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (res) {
                layer.close(loading);
                if (res.status === 200 || res.code === 200) {
                    var url = res.data;

                    // 1. 更新页面上的图片
                    $("#avatarImg").attr("src", url);
                    // 2. 更新表单里的隐藏域
                    $("#avatarPath").val(url);

                    // 3. 【核心逻辑】立即调用保存函数，传入 true 表示这是自动保存头像
                    saveData(true);

                } else {
                    layer.msg("上传失败：" + (res.message || "未知错误"), {icon: 2});
                }
            },
            error: function() {
                layer.close(loading);
                layer.msg("上传接口异常", {icon: 2});
            }
        });
    }

    // 保存资料
    // isAutoAvatarSave: boolean, 如果是 true，说明是换头像触发的自动保存
    function saveData(isAutoAvatarSave) {
        $.ajax({
            url: '/user/saveProfile',
            type: 'POST',
            data: $("#editPanel").serialize(), // 序列化整个表单
            success: function (res) {
                if (res.status === 200 || res.code === 200) {

                    if (isAutoAvatarSave) {
                        // 自动保存头像：简单提示并刷新
                        layer.msg("头像更换成功！", {icon: 1, time: 1000}, function(){
                            location.reload();
                        });
                    } else {
                        // 手动保存资料：正常提示并刷新
                        layer.msg("资料修改已保存！", {icon: 1, time: 1000}, function(){
                            location.reload();
                        });
                    }

                } else {
                    layer.msg(res.message || "保存失败", {icon: 2});
                }
            },
            error: function() {
                layer.msg("请求失败", {icon: 2});
            }
        });
    }

    // 快速发布草稿
    function quickPublish(id) {
        layer.confirm('确定要发布这篇文章吗？', {icon: 3, title:'发布确认'}, function(){
            $.post('/user/article/publish', {id: id}, function(res){
                if(res.status===200 || res.code===200){
                    layer.msg("发布成功", {icon:1, time:1000}, function(){ location.reload(); });
                } else {
                    layer.msg(res.message || "发布失败", {icon:2});
                }
            });
        });
    }

    // 删除文章
    function deleteArticle(id) {
        layer.confirm('删除后无法恢复，确定要删除吗？', {icon: 3, title:'删除确认'}, function(index){
            $.post('/user/article/delete', {id: id}, function(res){
                if(res.status===200 || res.code===200){
                    layer.msg("删除成功", {icon:1, time:1000}, function(){ location.reload(); });
                } else {
                    layer.msg(res.message || "删除失败", {icon:2});
                }
            });
        });
    }

</script>
