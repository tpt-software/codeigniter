<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		// <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Member list</title>
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
            <form id="fromSearch" class="layui-form layui-form-so" action="<?=site_url('user')?>" method="post" style="padding-top: 10px">
                <div class="layui-form-item">
                    <label class="layui-form-label">Date</label>
                    <div class="layui-input-inline">
                        <input name="kstime" id="kstime" type="text" value="<?=$kstime?>" class="layui-input w120" /> 
                    </div>
                    <div class="layui-input-inline">-</div>
                    <div class="layui-input-inline">
                        <input name="jstime" id="jstime" value="<?=$jstime?>" type="text" class="layui-input w120" />
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select name="zd">
                               <option value="name"<?php if($zd=='name') echo ' selected';?>>Member account</option>
                               <option value="email"<?php if($zd=='email') echo ' selected';?>>Email</option>
                               <option value="id"<?php if($zd=='id') echo ' selected';?>>Member ID</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <input type="text" name="key" value="<?=$key?>" class="layui-input w250">
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="zt">
                               <option value="0">State</option>
                               <option value="1"<?php if($zt==1) echo ' selected';?>>Audited</option>
                               <option value="2"<?php if($zt==2) echo ' selected';?>>To be reviewed</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="vip">
                               <option value="0">Type of membership</option>
                               <option value="1"<?php if($vip==1) echo ' selected';?>>Normal member</option>
                               <option value="2"<?php if($vip==2) echo ' selected';?>>VIP member</option>
                            </select>
                        </div>
                    </div>
                     <div class="layui-input-inline">
                        <button class="layui-btn"  id="searchBtn" type="submit">Submit</button>
                        <input type="hidden" id="sort_field" name="sort_field" value="<?php echo isset($sField) ? $sField : ''; ?>" />
                        <input type="hidden" id="sort_by" name="sort_by" value="<?php echo isset($sBy) ? $sBy : ''; ?>" />
                    </div>
                </div>
            </form>
            <style type="text/css">
            	.layui-table td, .layui-table th{text-align: center;}
				.layui-btn+.layui-btn{margin-left: 2px;}
				.layui-btn-mini{height: 20px;line-height: 20px;padding: 0 3px;}
				.layui-table td, .layui-table th{padding: 9px 5px;}
            </style>
            <form class="layui-form" action="<?=site_url('user/del')?>" method="post">
                <table class="layui-table">
                    <colgroup>
                        <col width="40">
                        <col>
                    </colgroup>
                    <?php 
                       $cssSort = '';
                        if($sBy == 'asc') {
                            $cssSort = 'fa-sort-asc';
                        } elseif ($sBy == 'desc') {
                            $cssSort = 'fa-sort-desc';
                        }
                    ?>
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th><a href="javascript:void(0)" onclick="sortby('id')" class="sortViews"><font color="#409ffd">ID </font><i class="fa <?= $sField == 'id' ? $cssSort : ''; ?>"></i><a></th>
                            <th><a href="javascript:void(0)" onclick="sortby('name')" class="sortViews"><font color="#409ffd">Account </font><i class="fa <?= $sField == 'name' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('email')" class="sortViews"><font color="#409ffd">Email </font><i class="fa <?= $sField == 'email' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('url')" class="sortViews"><font color="#409ffd">Website address </font><i class="fa <?= $sField == 'url' ? $cssSort : ''; ?>"></i><a></th>
							<th class="hide"><a href="javascript:void(0)" onclick="sortby('qq')" class="sortViews"><font color="#409ffd">Telegram </font><i class="fa <?= $sField == 'qq' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('total_video')" class="sortViews"><font color="#409ffd">Total videos </font><i class="fa <?= $sField == 'total_video' ? $cssSort : ''; ?>"></i><a></th>
                            <th><a href="javascript:void(0)" onclick="sortby('vip')" class="sortViews"><font color="#409ffd">Type </font><i class="fa <?= $sField == 'vip' ? $cssSort : ''; ?>"></i><a></th>
                            <th><a href="javascript:void(0)" onclick="sortby('zt')" class="sortViews"><font color="#409ffd">Status </font><i class="fa <?= $sField == 'zt' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('addtime')" class="sortViews"><font color="#409ffd">Time </font><i class="fa <?= $sField == 'addtime' ? $cssSort : ''; ?>"></i><a></th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        if(empty($user)) echo '<tr><td align="center" height="50" colspan="9">No relevant records have been found</td></tr>';
                        foreach ($user as $row) {
                            $status = '<font color=#080>Audited</font>';
                            if($row->zt==1){
								$status = '<font color=#f60>To be reviewed</font>';
							}
                            $vips = '<font color=#080>Normal member</font>';
                            if($row->vip==1){
								$vips = '<font color=#f60><i class="fa fa-star"></i> VIP Member</font>';
							}
                           
                            echo '
                            <tr id="row_'.$row->id.'">
                            <td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>
                            <td>'.$row->id.'</td>
                            <td>'.$row->name.'</td>
                            <td class="hide">'.$row->email.'</td>
                            <td class="hide">'.$row->url.'</td>
							<td class="hide">'.$row->qq.'</td>
                            <td>'.$row->total_video.'</td>
                            <td>'.$vips.'</td>
                            <td>'.$status.'</td>
                            <td class="hide">'.date('H:i:s | d-m-Y',$row->addtime).'</td>
                            <td class="basedb-more">
                                <a class="layui-btn layui-btn-mini layui-btn-normal" href="javascript:get_open(\''.site_url('user/edit/'.$row->id).'\',\'Member modification\',\'70%\',\'500px\');">Edit</a>
								<a class="layui-btn layui-btn-mini layui-btn-danger" href="javascript:del_one(\''.site_url('user/del').'\','.$row->id.');">Delete</a></td>
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
        <script type="text/javascript">
        	var laydate;
            layui.use('laydate', function(){
                laydate = layui.laydate;
                getTime('kstime');
                getTime('jstime');
            });
            function sortby(field) {
                $('#sort_field').val(field);
                if($('#sort_by').val() === 'desc') {
                    $('#sort_by').val('asc');
                } else {
                    $('#sort_by').val('desc');
                }
                $('#fromSearch').submit();
            }
            $(document).ready(function(){
                $('#searchBtn').click(function() {
                    $('#sort_field').val('');
                    $('#sort_by').val('');
                });
            })
        </script>
	</body>
</html>