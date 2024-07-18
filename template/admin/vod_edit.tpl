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
	<body style="padding: 10px">
	<form class="layui-form" action="<?=site_url('vod/save/'.$vod->id)?>" method="post">
        <table class="layui-table">
            <colgroup>
                <col width="120">
                <col>
            </colgroup>
            <tbody>
                <tr><td align="center">Video name</td><td><input type="text" name="name" placeholder="Please enter a category name" value="<?=$vod->name?>" class="layui-input"></td></tr>
                <tr><td align="center">Original file address</td><td><input type="text" name="filepath" placeholder="" value="<?=$vod->filepath?>" class="layui-input"></td></tr>
                <tr><td align="center">System classification</td><td>
                            <select name="cid">
                               <option value="0">Video classification</option>
							<?php 
								foreach ($vlist as $row2) {
									$sel = $vod->cid == $row2->id ? ' selected' : '';
									echo '<option value="'.$row2->id.'"'.$sel.'>'.$row2->name.'</option>';
								}
							?>
                            </select>
                </td></tr>
                <tr><td align="center">Transcoding status</td><td>
                            <select name="zt">
                               <option value="0">To be transcoded</option>
                               <option value="1"<?php if($vod->zt==1) echo ' selected';?>>Transcoding</option>
                               <option value="2"<?php if($vod->zt==2) echo ' selected';?>>Completed</option>
                               <option value="3"<?php if($vod->zt==3) echo ' selected';?>>Failed</option>
                            </select>
                </td></tr>
                <?php if($vod->is_remote_m3u8): ?>
                    <tr>
                        <td>Thumnail Image url</td>
                        <td><input type="text" name="thumnail_url" placeholder="" value="<?=$vod->thumnail_url?>" class="layui-input"></td>
                    </tr>
                    <tr>
                        <td>M3U8 url</td>
                        <td><input type="text" name="m3u8_url" placeholder="" value="<?=$vod->m3u8_url?>" class="layui-input"></td>
                    </tr>
                <?php endif; ?>
                <tr><td align="center" colspan="2"><button class="layui-btn" lay-submit lay-filter="edit">Submit</button></td></tr>
            </tbody>
        </table>
	</form>
	<script src="/packs/admin/js/common.js"></script>
	</body>
</html>