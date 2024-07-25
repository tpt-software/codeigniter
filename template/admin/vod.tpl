<!DOCTYPE html>
<html>
 <head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
  // <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
  <meta http-equiv="X-UA-Compatible" content="IE=9">
  <title>Video list</title>
  <link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css">
  <link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
  <link rel="stylesheet" type="text/css" href="/packs/font/font.css">
  <link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
  <link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
  <script src="/packs/jquery/jquery.min.js"></script>
  <script src="/packs/layui/layui.js"></script>
  <script type="text/javascript" src="/packs/assets/js/common.js"></script>
  <link rel="stylesheet" href="/packs/assets/font-awesome/css/font-awesome.min.css">
 </head>
 <body>
    <?= $header ?>
	<?= $leftsidebar ?>
    <div class="main">
        <div class="layui-tab-content" style="min-height: 360px;">
            <form id="fromSearch" class="layui-form layui-form-so" action="<?=site_url('vod')?>" method="post" style="padding-top: 10px">
			<?php
				$totalSize = 0;
				foreach ($vod as $row) {
				$totalSize += $row->size;
				}
			?> 
				<div style="font-size: 18px;"><strong>Total Size: <span style="color: red;"><?= $sizecus ?> TB</span></strong></div>
				<div style="font-size: 18px;"><strong>Total Size 1 page: <span style="color: red;"><?= formatsize($totalSize) ?></span></strong></div>
					<br>
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
                               <option value="name"<?php if($zd=='name') echo ' selected';?>>Video name</option>
                               <option value="id"<?php if($zd=='id') echo ' selected';?>>Video ID</option>
                               <option value="uid"<?php if($zd=='uid') echo ' selected';?>>Member ID</option>
                               <option value="mycid"<?php if($zd=='mycid') echo ' selected';?>>Private category id</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <input type="text" name="key" value="<?=$key?>" class="layui-input w120">
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="cid">
                               <option value="0">Video classification</option>
                                <?php 
                                    foreach ($vlist as $key => $value) {
                                        $sel = $cid == $key ? ' selected' : '';
                                        echo '<option value="'.$key.'"'.$sel.'>'.$value.'</option>';
                                    }
                                ?>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="fid">
                               <option value="0">Server</option>
                                <?php 
                                    foreach ($server as $key => $value) {
                                        $sel = $fid == $key ? ' selected' : '';
                                        echo '<option value="'.$key.'"'.$sel.'>'.$value.'</option>';
                                    }
                                ?>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="zt">
                               <option value="0">Status</option>
                               <option value="1"<?php if($zt==1) echo ' selected';?>>To be transcoded</option>
                               <option value="2"<?php if($zt==2) echo ' selected';?>>Transcoding</option>
							   <option value="3"<?php if($zt==3) echo ' selected';?>>Completed</option>
                               <option value="4"<?php if($zt==4) echo ' selected';?>>Failed</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <div class="vocation">
                            <select  name="vip">
                               <option value="0">Type</option>
                               <option value="1"<?php if($vip==1) echo ' selected';?>>Normal member</option>
                               <option value="2"<?php if($vip==2) echo ' selected';?>>VIP member</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-input-inline">
                        <button class="layui-btn" id="searchBtn" type="submit">Submit</button>
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
	.limited-width {
        max-width: 200px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
            </style>
            <form class="layui-form" action="<?=site_url('vod/del')?>" method="post">
                <table class="layui-table">
                    <colgroup>
                        <col width="40">
                        <col>
                    </colgroup>
                    <thead>
                        <?php 
                            $cssSort = '';
                            if($sBy === 'asc') {
                                $cssSort = 'fa-sort-asc';
                            } elseif ($sBy === 'desc') {
                                $cssSort = 'fa-sort-desc';
                            }
                        ?>
                        <tr>
                            <th>Select</th>
                            <th><a href="javascript:void(0)" onclick="sortby('id')" class="sortViews"><font color="#409ffd">ID </font><i class="fa <?= $sField == 'id' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('name')" class="sortViews"><font color="#409ffd">Name </font><i class="fa <?= $sField == 'name' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('fid')" class="sortViews"><font color="#409ffd">Server </font><i class="fa <?= $sField == 'fid' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('cid')" class="sortViews"><font color="#409ffd">System classification </font><i class="fa <?= $sField == 'cid' ? $cssSort : ''; ?>"></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('mycid')" class="sortViews"><font color="#409ffd">Private classification </font><i class="fa <?= $sField == 'mycid' ? $cssSort : ''; ?>"></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('hits')" class="sortViews"><font color="#409ffd">Views </font><i class="fa <?= $sField == 'hits' ? $cssSort : ''; ?>"></i><a></th>
                            <th><a href="javascript:void(0)" onclick="sortby('uid')" class="sortViews"><font color="#409ffd">Member ID </font><i class="fa <?= $sField == 'uid' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('duration')" class="sortViews"><font color="#409ffd">Durations </font><i class="fa <?= $sField == 'duration' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('size')" class="sortViews"><font color="#409ffd">Size </font><i class="fa <?= $sField == 'size' ? $cssSort : ''; ?>"></i><a></th>
                            <th><a href="javascript:void(0)" onclick="sortby('zt')" class="sortViews"><font color="#409ffd">Status </font><i class="fa <?= $sField == 'zt' ? $cssSort : ''; ?>"></i><a></th>
                            <th class="hide"><a href="javascript:void(0)" onclick="sortby('addtime')" class="sortViews"><font color="#409ffd">Release time </font><i class="fa <?= $sField == 'addtime' ? $cssSort : ''; ?>"></i><a></th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        if(empty($vod)) echo '<tr><td align="center" height="50" colspan="13">No relevant records have been found</td></tr>';
                        foreach ($vod as $row) {
                            if($row->zt==1){
								$status = '<font color=#1e9fff><span class="spinner-icon"><i class="fa fa-spinner fa-spin"></i> Transcoding...</span></font>';
							}elseif($row->zt==2){
                              
                                $status = '<font color=green><i class="fa fa-check-square-o"></i> Transcoded</font>';
                            }elseif($row->zt==3){
                                $status = '<font color=red><i class="fa fa-window-close-o"> Transcoding failed</font>';
                            }else{
                                $status = '<font color=#f90>Waiting for transcoding</font>';
                            }
                          
                            $cname = ' -- ';
                            $sname = ' -- ';
                            
                            if($row->cid > 0) {
                                if (array_key_exists($row->cid, $vlist)) {
                                    $cname = $vlist[$row->cid];
                                }
                            }
                            if($row->mycid > 0) {
                                if (array_key_exists($row->mycid, $myclass)) {
                                    $sname = $myclass[$row->mycid];
                                }
                            }
                            $playurl = links('play','index',$row->vid,'',1);
                            $fname = 'Default server';
                            if($row->fid > 0) {
                                if (array_key_exists($row->fid, $server)) {
                                    $fname = $server[$row->fid];
                                }
                            }
                            echo '
                            <tr id="row_'.$row->id.'">
                            <td>
                                <input name="id['.$row->id.']" 
                                lay-ignore class="xuan" 
                                type="checkbox" 
                                value="'.$row->id.'" 
                                data-row="'.htmlspecialchars(json_encode($row)).'"      
                                data-cname="'.$cname.'"      
                                data-zt="'.$row->zt.'"   
                                />
                            </td>
                            <td>'.$row->id.'</td>
                            <td style="text-align: left;" class="limited-width"><a class="plink" sid="'.$row->zt.'" href="javascript:layer.msg(\'Transcoding not complete...\');" _href="'.$playurl.'" title="'.$row->name.'">'.$row->name.'</a></td>
                            <td class="hide">'.$fname.'</td>
							<td class="hide">'.$cname.'</td>
                            <td class="hide">'.$sname.'</td>
                            <td class="hide">'.$row->hits.'</td>
                            <td>'.$row->uid.'</td>
                            <td class="hide">'.formattime((int)$row->duration,1).'</td>
                            <td class="hide">'.formatsize($row->size).'</td>
                            <td id="zm_'.$row->id.'">'.$status.'</td>
                            <td class="hide">'.date('H:i:s | d-m-Y',$row->addtime).'</td>
                            <td class="basedb-more">
                                <a class="layui-btn layui-btn-mini" href="javascript:get_open(\''.site_url('vod/show/'.$row->id).'\',\'Video details display\',\'80%\',\'600px\');">Details</a>
                                <a class="layui-btn layui-btn-mini layui-btn-normal" href="javascript:get_open(\''.site_url('vod/edit/'.$row->id).'\',\'Video modification\',\'60%\',\'400px\');">Edit</a>
								<a class="layui-btn layui-btn-mini layui-btn-danger" href="javascript:del_one(\''.site_url('vod/del').'\','.$row->id.');">Delete</a></td>
                            </tr> ';
                        }
                    ?>
                    </tbody>
                </table>
                <div class="more_func">
                    <a class="layui-btn layui-btn-primary layui-btn-small" href="javascript:select_all();"><i class="fa fa-check colorl" ></i>Select all</a>
                    <a class="layui-btn layui-btn-primary layui-btn-small" lay-submit lay-filter="del_pl"><i class="fa fa-close " style="color: red" ></i>Delete selected</a>
                    <a class="layui-btn layui-btn-primary layui-btn-small" style="background: #36c6d3; color: #fff;" onclick="handleLinkChoose()"><i class="fa fa-bars"></i> Export link selected</a>
                </div>
            </form>
            <div id="page"> 
                <div class="data_nums phide"><?=$page_data?></div>
                <div class="data_page"><?=$page_list?></div>
            </div>
        </div>
<script src="/packs/admin/js/vod.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.4/xlsx.full.min.js"></script>
<script src="/packs/admin/js/clipboard.min.js"></script>
<script src="/packs/admin/js/common.js?v=1.4"></script>
<script type="text/javascript">
    var v = [];
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
$('.plink').each(function(){
                    var sid = $(this).attr('sid');
                    var link = $(this).attr('_href');
                    if(sid == '2'){
                        $(this).attr('href',link).attr('target','play');
                    }
                });
    var a = $(".xuan");
    for(var n = 0; n < a.length; n++) {
     v.push(a[n].value);
    }
    setInterval("get_zt()",5000);
   });
   function get_zt(){
       $.post('<?=links('vod','ajax')?>',{did:v.join(',')},function(d){
     d.forEach(function(value,i){
      if(d[i].zt == 1){
       $("#zm_"+value.id).html('<font color=#1e9fff><span class="spinner-icon"><i class="fa fa-spinner fa-spin"></i> Transcoding...</span></font>');
      } else if(value.zt == 2){
         $("#zm_" + value.id).html('<font color=green><i class="fa fa-check-square-o"></i> Transcoded</font>');
      } else if(value.zt == 3){
       $("#zm_"+value.id).html('<font color=red>Transcoding failed</font>');
      }
     });
    },'json');
   }
        </script>
    </div>
        
 </body>
</html>