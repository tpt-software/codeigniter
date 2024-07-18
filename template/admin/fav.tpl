<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>Video favorite list</title>
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
                <form class="layui-form layui-form-so" action="<?=site_url('fav')?>" method="post" style="padding-top: 10px">
                    <div class="layui-form-item">
                        <label class="layui-form-label">Date</label>
                        <div class="layui-input-inline">
                            <input name="kstime" id="kstime" type="text" value="<?=$kstime?>" class="layui-input w120" /> 
                        </div>
                        <div class="layui-input-inline">-</div>
                        <div class="layui-input-inline">
                            <input name="jstime" id="jstime" value="<?=$jstime?>" type="text" class="layui-input w120" />
                        </div>
                        <label class="layui-form-label">Video ID</label>
                        <div class="layui-input-inline">
                            <input type="text" name="did" value="<?=$did==0 ? '' : $did;?>" class="layui-input w250">
                        </div>
                        <div class="layui-input-inline">
                            <div class="vocation">
                                <select  name="cid">
                                <option value="0">Video classification</option>
                                <?php 
                                    foreach ($vlist as $row2) {
                                        $sel = $cid == $row2->id ? ' selected' : '';
                                        echo '<option value="'.$row2->id.'"'.$sel.'>'.$row2->name.'</option>';
                                    }
                                ?>
                                </select>
                            </div>
                        </div>
                        <div class="layui-input-inline">
                            <button class="layui-btn" type="submit">Submit</button>
                        </div>
                    </div>
                </form>
                <style type="text/css">
                    .layui-table td, .layui-table th{text-align: center;}
                    .layui-btn+.layui-btn{margin-left: 2px;}
                    .layui-btn-mini{height: 20px;line-height: 20px;padding: 0 3px;}
                    .layui-table td, .layui-table th{padding: 9px 5px;}
                </style>
                <form class="layui-form" action="<?=site_url('fav/del')?>" method="post">
                    <table class="layui-table">
                        <colgroup>
                            <col width="40">
                            <col width="100">
                            <col>
                            <col width="120">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>Select</th>
                                <th>ID</th>
                                <th>Video name</th>
                                <th class="hide">System classification</th>
                                <th>Member ID</th>
                                <th class="hide">Time</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <?php
                            if(empty($vod)) echo '<tr><td align="center" height="50" colspan="7">No relevant records have been found</td></tr>';
                            foreach ($vod as $row) {
                                $vod = $this->csdb->get_row('vod','*',array('id'=>$row->did));
                                if(!$vod) continue;
                                $sname = ' -- ';
                                if($row->cid>0) $cname = getzd('class','name',$row->cid);
                                $playurl = links('play','index',$vod->vid,'',1);
                                echo '
                                <tr id="row_'.$row->id.'">
                                <td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>
                                <td>'.$row->id.'</td>
                                <td style="text-align: left;"><a target="play" href="'.$playurl.'">'.$vod->name.'</a></td>
                                <td class="hide">'.$cname.'</td>
                                <td>'.$row->uid.'</td>
                                <td class="hide">'.date('Y-m-d H:i:s',$row->addtime).'</td>
                                <td class="basedb-more">
                                    <a class="layui-btn layui-btn-mini layui-btn-danger" href="javascript:del_one(\''.site_url('fav/del').'\','.$row->id.');">Delete</a></td>
                                </tr> ';
                            }
                        ?>
                        </tbody>
                    </table>
                    <div class="more_func">
                        <a class="layui-btn layui-btn-primary layui-btn-small" href="javascript:select_all();"><i class="fa fa-check colorl" ></i>Select All/Cancel</a>
                        <a class="layui-btn layui-btn-primary layui-btn-small" lay-submit lay-filter="del_pl"><i class="fa fa-close " style="color: red" ></i>Delete selected</a>
                    </div>
                </form>
                <div id="page">
                    <div class="data_nums phide"><?=$page_data?></div>
                    <div class="data_page"><?=$page_list?></div>
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
            </script>
        </div>
	</body>
</html>