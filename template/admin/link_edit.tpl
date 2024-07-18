<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
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
	<form class="layui-form" action="<?=site_url('link/save/'.$id)?>" method="post">
        <table class="layui-table">
            <colgroup>
                <col width="120">
                <col>
            </colgroup>
            <tbody>
                <tr><td align="center">Title</td><td><input type="text" name="name" placeholder="Please enter a title" value="<?=$name?>" class="layui-input"></td></tr>
                <tr><td align="center">Address</td><td><input type="text" name="url" placeholder="Please enter address" value="<?=$url?>" class="layui-input"></td></tr>
                <tr><td align="center" colspan="2"><button class="layui-btn" lay-submit lay-filter="edit">Submit</button></td></tr>
            </tbody>
        </table>
	</form>
	<script src="/packs/admin/js/common.js"></script>
<script src="/sys/system/language/english/vodgwgl.php"></script>
  </body>
</html>