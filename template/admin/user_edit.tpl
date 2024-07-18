<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Member modification</title>
		<link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
		<link rel="stylesheet" type="text/css" href="/packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="/packs/jquery/jquery.min.js"></script>
		<script src="/packs/layui/layui.js"></script>
	</head>
	<body style="padding: 10px">
	<form class="layui-form" action="<?=site_url('user/save/'.$user->id)?>" method="post">
        <table class="layui-table">
            <colgroup>
                <col width="120">
                <col>
            </colgroup>
            <tbody>
                <tr><td align="center">Member account</td><td><input type="text" name="name" placeholder="Please enter a category name" value="<?=$user->name?>" class="layui-input"></td></tr>
                <tr><td align="center">Login password</td><td><input type="text" name="pass" placeholder="Do not modify please leave blank" value="" class="layui-input"></td></tr>
                <tr><td align="center">Email</td><td><input type="text" name="email" placeholder="Please enter your contact email" value="<?=$user->email?>" class="layui-input"></td></tr>
				<tr><td align="center">Telegram</td><td><input type="text" name="qq" placeholder="Please enter contact Telegram" value="<?=$user->qq?>" class="layui-input"></td></tr>
                <tr><td align="center">Website address</td><td><input type="text" name="url" placeholder="Please enter the website address" value="<?=$user->url?>" class="layui-input"></td></tr>
				<tr><td align="center">Telegram</td><td><input type="text" name="telegram" placeholder="Please enter Telegram account" value="<?=$user->telegram?>" class="layui-input"></td></tr>
                <tr><td align="center">Type of membership</td><td>
                            <select name="vip">
                               <option value="0">Normal member</option>
                               <option value="1"<?php if($user->vip==1) echo ' selected';?>>VIP member</option>
                            </select>
                </td></tr>
                <tr><td align="center">Membership status</td><td>
                            <select name="zt">
                               <option value="0">Audited</option>
                               <option value="1"<?php if($user->zt==1) echo ' selected';?>>To be reviewed</option>
                            </select>
                </td></tr>
                <tr><td align="center" colspan="2"><button class="layui-btn" lay-submit lay-filter="edit">Submit</button></td></tr>
            </tbody>
        </table>
	</form>
	<script src="/packs/admin/js/common.js"></script>
	</body>
</html>