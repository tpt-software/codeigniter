<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Video list</title>
		<link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
		<link rel="stylesheet" type="text/css" href="/packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="/packs/jquery/jquery.min.js"></script>
		<script src="/packs/layui/layui.js"></script>
	</head>
	<body>
        <?= $header ?>
		<?= $leftsidebar ?>
        <div class="main">
            <div class="layui-tab-content" style="min-height: 360px;">
            <form class="layui-form layui-form-so" action="<?=site_url('server')?>" method="post" style="padding-top: 10px">
                <div class="layui-form-item">
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select name="zd">
                               <option value="name"<?php if($zd=='name') echo ' selected';?>>Name of server</option>
                               <option value="id"<?php if($zd=='id') echo ' selected';?>>Server ID</option>
                               <option value="apiurl"<?php if($zd=='apiurl') echo ' selected';?>>Address</option>
                               <option value="cdnurl"<?php if($zd=='cdnurl') echo ' selected';?>>CDN address</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <input type="text" name="key" value="<?=$key?>" class="layui-input w250">
                    </div>
                     <div class="layui-input-inline">
                        <button class="layui-btn" type="submit">Inquire</button>
                    </div>
                </div>
            </form>
            <style type="text/css">
            	.layui-table td, .layui-table th{text-align: center;}
				.layui-btn+.layui-btn{margin-left: 2px;}
				.layui-btn-mini{height: 20px;line-height: 20px;padding: 0 3px;}
				.layui-table td, .layui-table th{padding: 9px 5px;}
            </style>
            <div class="layui-form-item">
                <div class="layui-input-inline">
                    <button class="layui-btn layui-btn-normal" onclick="get_open('<?=site_url('server/edit')?>','Add new server','60%','480px');" type="button">Add new server</button>
                </div>
            </div>
            <form class="layui-form" action="<?=site_url('vod/del')?>" method="post">
                <table class="layui-table">
                    <colgroup>
                        <col width="40">
                        <col>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th class="hide">Type</th>
                            <th class="hide">Address</th>
                            <th class="hide">Total number of plays</th>
                            <th class="hide">Queue limit</th>
                            <th>Total size</th>
                            <th>Used</th>
                            <th class="hide">Waiting for transcoding</th>
                            <th class="hide">Transcoding</th>
                            <th class="hide">Completed</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        if(empty($server)) echo '<tr><td align="center" height="50" colspan="12">No relevant records have been found</td></tr>';
                        foreach ($server as $row) {
                            $num1 = $this->csdb->get_nums('vod',array('zt'=>0,'fid'=>$row->id));
                            $num2 = $this->csdb->get_nums('vod',array('zt'=>1,'fid'=>$row->id));
                            $num3 = $this->csdb->get_nums('vod',array('zt'=>2,'fid'=>$row->id));
							$type = $row->vip == 1 ? '<font color=red>VIP only</font>' : 'Normal';
                            echo '
                            <tr id="row_'.$row->id.'">
                            <td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>
                            <td>'.$row->id.'</td>
                            <td>'.$row->name.'</td>
                            <td class="hide">'.$type.'</td>
                            <td class="hide">'.$row->apiurl.'</td>
                            <td class="hide">'.$this->csdb->get_sum('hits','vod',array('fid'=>$row->id)).'</td>
                            <td class="hide">'.$row->zmnum.'</td>
                            <td>'.formatsize($row->zsize).'</td>
                            <td>'.formatsize($row->size).'</td>
                            <td class="hide">'.$num1.'</td>
                            <td class="hide">'.$num2.'</td>
                            <td class="hide">'.$num3.'</td>
                            <td class="basedb-more">
                                <a class="layui-btn layui-btn-mini layui-btn-normal" href="javascript:get_open(\''.site_url('server/edit/'.$row->id).'\',\'Video modification\',\'60%\',\'480px\');">Edit</a>
								<a class="layui-btn layui-btn-mini layui-btn-danger" href="javascript:del_one(\''.site_url('server/del').'\','.$row->id.');">Delete</a></td>
                            </tr> ';
                        }
                    ?>
                    </tbody>
                </table>
                <div class="more_func">
                    <a class="layui-btn layui-btn-primary layui-btn-small" href="javascript:select_all();"><i class="fa fa-check colorl" ></i>Select all</a>
                    <a class="layui-btn layui-btn-primary layui-btn-small" lay-submit lay-filter="del_pl"><i class="fa fa-close " style="color: red" ></i>Delete selected</a>
                </div>
            </form>
            <div id="page">
                <div class="data_nums phide"><?=$page_data?></div>
                <div class="data_page"><?=$page_list?></div>
            </div>
        </div>
        </div>
		
		<script src="/packs/admin/js/common.js?v=1.4"></script>
	</body>
</html>