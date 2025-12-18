<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>登录 - OneBlog</title>
    <!-- ⚠️ 这里换成了网络 CDN 地址，保证样式能加载出来 -->
    <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f5f5f5; }
        .login-container { max-width: 400px; margin: 100px auto; padding: 30px; background: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .login-title { text-align: center; margin-bottom: 30px; }
    </style>
</head>
<body>

<div class="container">
    <div class="login-container">
        <h3 class="login-title">用户登录</h3>
        <form id="loginForm">
            <div class="form-group">
                <label>用户名</label>
                <input type="text" class="form-control" name="username" placeholder="请输入用户名" required>
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" class="form-control" name="password" placeholder="请输入密码" required>
            </div>
            <button type="button" class="btn btn-primary btn-block" onclick="submitLogin()">登录</button>
            <div style="margin-top: 15px; text-align: right;">
                <a href="/register">没有账号？去注册</a> | <a href="/">返回首页</a>
            </div>
        </form>
    </div>
</div>

<!-- ⚠️ 这里换成了网络 CDN 地址，保证 jQuery 一定能加载 -->
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
    function submitLogin() {
        console.log("正在尝试登录...");

        // 检查 jQuery 是否加载成功
        if (typeof jQuery == 'undefined') {
            alert("jQuery 加载失败，请检查网络！");
            return;
        }

        $.ajax({
            url: '/login',
            type: 'POST',
            data: $("#loginForm").serialize(),
            success: function(res) {
                console.log("返回结果：", res);
                if(res.status === 200) {
                    alert("登录成功！点击确定跳转首页");
                    window.location.href = "/";
                } else {
                    alert("登录失败：" + res.message);
                }
            },
            error: function(xhr) {
                console.error(xhr);
                alert("请求出错，请按F12查看控制台");
            }
        });
    }
</script>
</body>
</html>