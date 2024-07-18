<!DOCTYPE html>
<html>
<head>
<style>
    .layui-input-block input::placeholder {
        color: rgba(255, 255, 255, 0.5); /* Màu trắng mờ */
        font-style: italic;
		font-size: 12px;
    }
</style>
	<meta charset=utf-8>
	<title><?=$title?></title>
	<meta name="robots" content="noindex,nofollow">
	<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<link rel="stylesheet" href="<?=Web_Path?>packs/font/font.css">
	<link rel="stylesheet" href="<?=Web_Path?>packs/admin/css/style.css">
	<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/layui.css">
	<link type="text/css" rel="stylesheet" href="<?=Web_Path?>packs/admin/css/login.css?v=1" />
	<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
	<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
	<script src="<?=Web_Path?>packs/layui/layui.js"></script>
	<script src="<?=Web_Path?>packs/jquery/jquery.min.js"></script>
</head>
<body class="login">
<section class="container">
    <div class="login-container">
      <div class="circle circle-one"></div>
      <div class="form-container">
	  <img src="<?=Web_Path?>packs/admin/images/illustration.png" alt="illustration" class="illustration" />
<div class="login-title">Admin login</div>
<form class="layui-form login-form" action="<?=links('login/save')?>" method="post">
    <div class="layui-form-item">
    <label class="layui-form-label"></label>
    <div class="layui-input-block">
        <input type="text" name="adminname" required lay-verify="required" autocomplete="off" class="layui-input" placeholder="USERNAME">
    </div>
</div>
<div class="layui-form-item">
    <label class="layui-form-label"></label>
    <div class="layui-input-block">
        <input type="password" name="adminpass" required lay-verify="required" class="layui-input" placeholder="PASSWORD">
    </div>
</div>

    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="opacity" lay-submit lay-filter="login">Login</button>
        </div>
    </div>
</form>
<div class="circle circle-two"></div>
    </div>
    <div class="theme-btn-container"></div>
</section>
<script src="<?=Web_Path?>packs/admin/js/common.js"></script>
<script src="<?=Web_Path?>packs/admin/js/script.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var inputs = document.querySelectorAll('.layui-input');
        inputs.forEach(function(input) {
            input.addEventListener('input', function () {
                input.parentNode.classList.toggle('has-content', input.value.length > 0);
            });
        });
    });
</script>
</body>
</html>