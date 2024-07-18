<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Video details page</title>
		<link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
		<link rel="stylesheet" type="text/css" href="/packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="/packs/jquery/jquery.min.js"></script>
		<script src="/packs/layui/layui.js"></script>
	</head>
	<body style="padding: 10px">
        <style type="text/css">a{color: #333;}a:hover{color:#ff5722;}</style>
        <table class="layui-table">
            <colgroup>
                <col width="120">
                <col>
            </colgroup>
            <?php
                $status = '<font color=#1e9fff>Waiting for transcoding</font>';
                if($vod->zt==1) $status = '<font color=#f60>Transcoding</font>';
                if($vod->zt==2) $status = '<font color=green>Transcoding complete</font>';
                if($vod->zt==3) $status = '<font color=red>Transcoding failed</font>';
                $rows = array();
                if($vod->fid > 0){
                    $rows = $this->csdb->get_row_arr('server','*',array('id'=>$vod->fid));
                }
            ?>
            <tbody>
                <tr><td align="center">Video name</td><td><?=$vod->name?></td></tr>
                <tr><td align="center">Status</td><td><?=$status?></td></tr>
                <tr><td align="center">Play address</td><td><a href="<?=links('play','index',$vod->vid,'',1)?>" target="_blank">https://<?=Web_Url.links('play','index',$vod->vid,'',1)?></a></td></tr>
				<tr><td align="center">Backup</td><td><a href="https://14412882.net/play/index/<?= $vod->vid ?>" target="_blank">https://14412882.net/play/index/<?= $vod->vid ?></a></td></tr>
				<?php 
                if(Jpg_On == 1){
                    if ($vod->is_remote_m3u8) {
                        echo '<tr><td align="center">Image address '.$i.'</td><td><a href="'.$row->thumnail_url.'" target="_blank">'.$row->thumnail_url.'</a></td></tr>';
                    } else {
                        for($i=1;$i<=Jpg_Num;$i++){ 
                            $piclink = m3u8_link($vod->vid,$vod->addtime,'pic',$i,$rows);
                            echo '<tr><td align="center">Image address '.$i.'</td><td><a href="'.$piclink.'" target="_blank">'.$piclink.'</a></td></tr>';
                        }
                    }
                    
				}
                $m3u8link = m3u8_link($vod->vid,$vod->addtime,'m3u8',1,$rows);
                ?>
                <?php if ($vod->is_remote_m3u8): ?>
                    <tr><td align="center">M3U8 address</td><td><a href="<?= $vod->m3u8_url ?>" target="_blank"><?= $vod->m3u8_url ?></a></td></tr>
                <?php else: ?>
                    <tr><td align="center">M3U8 address</td><td><a href="<?=$m3u8link?>" target="_blank"><?=$m3u8link?></a></td></tr>
                <?php endif; ?>
                
            </tbody>
        </table>
		<script src="/packs/admin/js/common.js"></script>
	</body>
</html>