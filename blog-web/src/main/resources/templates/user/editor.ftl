<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>写文章 - ${config.siteName!"OneBlog"}</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.bootcdn.net/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <style>
        body { background-color: #f5f5f5; padding-top: 20px; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
        .editor-container { background: #fff; padding: 30px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,.1); min-height: 80vh; max-width: 1000px; margin: 0 auto; position: relative; }
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px;}
        .article-title { flex: 1; border: none; font-size: 24px; font-weight: bold; outline: none; margin-right: 20px; height: 40px; background: transparent;}

        #editor { z-index: 10; position: relative; }
        .w-e-toolbar { border: 1px solid #ccc !important; border-bottom: none !important; border-radius: 4px 4px 0 0; background-color: #fcfcfc !important; flex-wrap: wrap;}
        .w-e-text-container { border: 1px solid #ccc !important; border-radius: 0 0 4px 4px; min-height: 600px !important; z-index: 100 !important;}

        .option-label { margin-right: 15px; font-weight: normal; cursor: pointer;}
        .tag-checkbox { margin-right: 5px; }
    </style>
</head>
<body>

<div class="container">
    <div class="editor-container">
        <!-- 1. 顶部操作栏 -->
        <div class="top-bar">
            <input type="text" id="title" class="article-title" placeholder="请输入文章标题..." value="${(article.title)!}">
            <input type="hidden" id="articleId" value="${(article.id?c)!}">

            <div class="btn-group">
                <button class="btn btn-default" onclick="goBack()"><i class="fa fa-reply"></i> 返回</button>
                <button class="btn btn-warning" onclick="saveArticle(0)"><i class="fa fa-save"></i> 存草稿</button>
                <button class="btn btn-primary" onclick="saveArticle(1)"><i class="fa fa-paper-plane"></i> 发布</button>
            </div>
        </div>

        <!-- 2. 属性设置区 -->
        <div class="row">
            <!-- 封面图 -->
            <div class="col-md-6">
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-image"></i> 封面</span>
                        <input type="text" id="coverImage" class="form-control" placeholder="文章封面图URL..." value="${(article.coverImage)!}">
                    </div>
                </div>
            </div>

            <!-- 分类选择 -->
            <div class="col-md-3">
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-folder-open"></i> 分类</span>
                        <select id="typeId" class="form-control">
                            <#if types?? && types?size gt 0>
                                <#list types as item>
                                    <option value="${item.id?c}" <#if (article.typeId)! == item.id>selected</#if>>${item.name}</option>
                                </#list>
                            <#else>
                                <option value="1">默认分类</option>
                            </#if>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 原创/转载 -->
            <div class="col-md-3">
                <div class="form-group" style="padding-top: 7px;">
                    <label class="option-label">
                        <input type="radio" name="original" value="1" <#if !(article.original)?? || article.original>checked</#if>> 原创
                    </label>
                    <label class="option-label">
                        <input type="radio" name="original" value="0" <#if (article.original)?? && !article.original>checked</#if>> 转载
                    </label>
                </div>
            </div>
        </div>

        <!-- 3. 标签选择区 (新增) -->
        <div class="form-group">
            <label><i class="fa fa-tags"></i> 文章标签：</label>
            <div style="padding: 10px; background: #f9f9f9; border-radius: 4px;">
                <#if tags?? && tags?size gt 0>
                    <#list tags as tag>
                        <label class="option-label">
                            <!-- 判断回显：如果 article.keywords 包含标签名，则选中 -->
                            <input type="checkbox" name="tagIds" value="${tag.id?c}" class="tag-checkbox"
                                   <#if (article.keywords)?? && article.keywords?contains(tag.name)>checked</#if>
                            > ${tag.name}
                        </label>
                    </#list>
                <#else>
                    <span class="text-muted">暂无标签可选</span>
                </#if>
            </div>
        </div>

        <!-- 4. 编辑器 -->
        <div id="editor">
            ${(article.content)!}
        </div>
    </div>
</div>

<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.bootcdn.net/ajax/libs/layer/3.5.1/layer.min.js"></script>
<script src="https://unpkg.com/wangeditor@4.7.11/dist/wangEditor.min.js"></script>

<script>
    if (!window.wangEditor) { alert("编辑器资源加载失败"); }

    const E = window.wangEditor;
    const editor = new E('#editor');

    editor.config.uploadImgServer = '/user/upload';
    editor.config.uploadFileName = 'file';
    editor.config.uploadImgMaxSize = 5 * 1024 * 1024;

    editor.config.customUploadImg = function (resultFiles, insertImgFn) {
        var formData = new FormData();
        formData.append("file", resultFiles[0]);
        $.ajax({
            url: '/user/upload',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                if(res.status === 200 || res.code === 200) {
                    insertImgFn(res.data);
                    if(!$("#coverImage").val()){ $("#coverImage").val(res.data); }
                } else { layer.msg("上传失败：" + res.message); }
            }
        });
    }

    editor.create();

    var isDirty = false;
    editor.config.onchange = function (html) { isDirty = true; }
    $('#title').on('input', function(){ isDirty = true; });

    // 保存/发布
    function saveArticle(type) {
        var title = $("#title").val();
        var content = editor.txt.html();
        var txt = editor.txt.text();
        var cover = $("#coverImage").val();
        var typeId = $("#typeId").val();
        var id = $("#articleId").val();

        // 获取原创/转载
        var original = $('input[name="original"]:checked').val() === '1'; // true or false

        // 获取选中的标签 ID 数组
        var tagIds = [];
        $('input[name="tagIds"]:checked').each(function(){
            tagIds.push($(this).val());
        });

        if(!title.trim()) { layer.msg("标题不能为空"); return; }
        if(!txt.trim() && !content.includes('<img')) { layer.msg("内容不能为空"); return; }
        if(!typeId) { layer.msg("请选择文章分类"); return; }

        var loading = layer.load(1);

        // 使用 traditional: true 以便后端 Long[] 数组能正确接收
        $.ajax({
            url: '/user/article/save',
            type: 'POST',
            traditional: true,
            data: {
                id: id,
                title: title,
                content: content,
                coverImage: cover,
                typeId: typeId,
                type: type,
                original: original, // 传布尔值
                tagIds: tagIds      // 传数组
            },
            success: function(res) {
                layer.close(loading);
                if(res.status === 200 || res.code === 200) {
                    isDirty = false;
                    layer.msg(res.message, {icon: 1, time: 1000}, function(){
                        window.location.href = "/user/profile";
                    });
                } else {
                    layer.msg(res.message, {icon: 2});
                }
            },
            error: function() {
                layer.close(loading);
                layer.msg("请求失败", {icon: 2});
            }
        });
    }

    function goBack() {
        if (isDirty) {
            layer.confirm('内容未保存，是否存为草稿？', {
                btn: ['存草稿', '直接退出']
            }, function(){
                saveArticle(0);
            }, function(){
                window.location.href = "/user/profile";
            });
        } else {
            window.location.href = "/user/profile";
        }
    }
</script>
</body>
</html>