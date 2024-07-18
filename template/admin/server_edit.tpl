<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Video modification</title>
		<link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
		<link rel="stylesheet" type="text/css" href="/packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="/packs/jquery/jquery.min.js"></script>
		<script src="/packs/layui/layui.js"></script>
	</head>
	<style type="text/css">
		.layui-table td, .layui-table th{padding:5px;}
		.layui-input{height: 30px;line-height: 30px;}
		.layui-table td span{cursor: pointer;position: absolute;right: 8px;top: 10px;background-color: #34a7fd;color: #fff;font-size: 12px;padding: 1px 7px;border-radius: 5px;}
	</style>
	<body style="padding: 10px">
	<form class="layui-form" action="<?=site_url('server/save/'.$id)?>" method="post">
        <table class="layui-table">
            <colgroup>
                <col width="120">
                <col>
            </colgroup>
            <tbody>
                <tr><td align="center">Server name</td><td><input type="text" name="name" placeholder="Please enter a server name" value="<?=$name?>" class="layui-input"></td></tr>
                <tr><td align="center">Address</td><td><input type="text" name="apiurl" placeholder="Please enter the access address" value="<?=$apiurl?>" class="layui-input"></td></tr>
                <tr><td align="center">Request key</td><td style="position: relative;"><input type="text" id="apikey" name="apikey" placeholder="Please enter request key" value="<?=$apikey?>" class="layui-input"><span onclick="ger_rand();">Rebuild</span></td></tr>
                <tr><td align="center">Queue limit</td><td><input type="text" name="zmnum" placeholder="Please enter the maximum number of transcoding queues" value="<?=$zmnum?>" class="layui-input" style="display: inline-block;width:150px;"> 个</td></tr>
                <tr><td align="center">Source file directory</td><td><input type="text" name="mp4dir" placeholder="Please enter the source file save directory" value="<?=$mp4dir?>" class="layui-input"></td></tr>
                <tr><td align="center">Slice directory</td><td><input type="text" name="m3u8dir" placeholder="Please enter the slice save directory" value="<?=$m3u8dir?>" class="layui-input"></td></tr>
                <tr><td align="center">CDN address</td><td><input type="text" name="cdnurl" placeholder="Please enter the M3U8 playback CDN address" value="<?=$cdnurl?>" class="layui-input"></td></tr>
                <tr><td align="center">SSD size</td><td><input type="text" name="zsize" placeholder="Please enter the total size of the hard disk, unit: G" value="<?=$zsize?>" class="layui-input" style="display: inline-block;width:150px;"> GB</td></tr>
                <tr><td align="center">Line type</td><td>
                            <select name="vip">
                               <option value="0">Normal line</option>
                               <option value="1"<?php if($vip==1) echo 'selected';?>>VIP exclusive</option>
                            </select>
                </td></tr>
                <tr><td align="center" colspan="2"><button class="layui-btn" lay-submit lay-filter="edit">Submit</button></td></tr>
            </tbody>
        </table>
	</form>
	<script src="/packs/admin/js/common.js"></script>
	<script>
	function ger_rand() {
	　　var len = 32;
	　　var chars = 'abcdefhijkmnprstwxyz123456789';
	　　var maxPos = chars.length;
	　　var pwd = '';
	　　for (i = 0; i < len; i++) {
	　　　　pwd += chars.charAt(Math.floor(Math.random() * maxPos));
	　　}
	　　$('#apikey').val(pwd);
	}
	</script>
	</body>
</html>