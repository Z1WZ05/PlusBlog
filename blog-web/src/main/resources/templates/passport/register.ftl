<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title>注册 - OneBlog</title>
    <!-- CDN CSS -->
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
        <h3 class="login-title">新用户注册</h3>
        <form id="regForm">
            <div class="form-group">
                <label>用户名 (登录账号)</label>
                <input type="text" class="form-control" name="username" required>
            </div>
            <div class="form-group">
                <label>昵称 (显示名字)</label>
                <input type="text" class="form-control" name="nickname" required>
            </div>
            <div class="form-group">
                <label>密码</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <button type="button" class="btn btn-success btn-block" onclick="submitReg()">注册</button>
            <div style="margin-top: 15px; text-align: right;">
                <a href="/login">已有账号？去登录</a>
            </div>
        </form>
    </div>
</div>

<!-- CDN JS -->
<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
    function submitReg() {
        $.ajax({
            url: '/register',
            type: 'POST',
            data: $("#regForm").serialize(),
            success: function(res) {
                if(res.status === 200) {
                    alert("注册成功！去登录吧");
                    window.location.href = "/login";
                } else {
                    alert("注册失败：" + (res.message || "未知错误"));
                }
            },
            error: function() {
                alert("网络请求失败");
            }
        });
    }
</script>
</body>
</html>