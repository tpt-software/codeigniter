<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title><?=$title?></title>
		<link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/admin/css/common.css">
		<link rel="stylesheet" type="text/css" href="<?=Web_Path?>packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="<?=Web_Path?>packs/jquery/jquery.min.js"></script>
		<script src="<?=Web_Path?>packs/layui/layui.js"></script>
	</head>
	<body>
		<?= $header ?>
		<?= $leftsidebar ?>
		<div class="main">
			<iframe name="iframe_0" id="iframe_main" src="<?=links('index/main')?>" style="border: 0px;width: 100%;height: 99.5%;"></iframe>
		</div>
		<script type="text/javascript" src="<?=Web_Path?>packs/admin/js/common.js?v=1.3"></script>
	</body>
</html>