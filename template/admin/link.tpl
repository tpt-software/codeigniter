<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<meta http-equiv="X-UA-Compatible" content="IE=9">
		<title>List</title>
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
            <style type="text/css">
            	.layui-table td, .layui-table th{text-align: center;}
				.layui-btn+.layui-btn{margin-left: 2px;}
				.layui-btn-mini{height: 20px;line-height: 20px;padding: 0 3px;}
				.layui-table td, .layui-table th{padding: 9px 5px;}
            </style>
            <div class="layui-form-item">
                <div class="layui-input-inline">
                    <button class="layui-btn layui-btn-normal" onclick="get_open('<?=site_url('link/edit')?>','Add','70%','280px');" type="button">Add link</button>
                </div>
            </div>
            <form class="layui-form" action="<?=site_url('link/del')?>" method="post">
                <table class="layui-table">
                    <thead>
                        <tr>
                            <th>Select</th>
                            <th>ID</th>
                            <th>Title</th>
                            <th class="hide">Address</th>
                            <th>Operate</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php
                        if(empty($link)) echo '<tr><td align="center" height="50" colspan="5">No relevant records have been found</td></tr>';
                        foreach ($link as $row) {
                            echo '
                            <tr id="row_'.$row->id.'">
                            <td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>
                            <td>'.$row->id.'</td>
                            <td>'.$row->name.'</td>
                            <td class="hide">'.$row->url.'</td>
                            <td class="basedb-more">
                                <a class="layui-btn layui-btn-mini layui-btn-normal" href="javascript:get_open(\''.site_url('link/edit/'.$row->id).'\',\'Account\',\'70%\',\'350px\');">Edit</a>
								<a class="layui-btn layui-btn-mini layui-btn-danger" href="javascript:del_one(\''.site_url('link/del').'\','.$row->id.');">Delete</a></td>
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
        </div>
        </div>
		
		<script src="/packs/admin/js/common.js?v=1.4"></script>
	</body>
</html>