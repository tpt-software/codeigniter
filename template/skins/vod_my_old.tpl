<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
    <head>
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layer/theme/default/layer.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/modules/layer/default/layer.css">
		<script src="<?=Web_Path?>packs/layui/layui.js"></script>
		<style>
    .custom-link-color {
        background-color: #03a9f4; /* Mã màu xanh bạn muốn sử dụng cho nền */
        color: #ffffff; /* Mã màu cho văn bản */
        border-color: #03a9f4; /* Mã màu xanh bạn muốn sử dụng cho đường viền (border) */
    }

    .custom-link-color:hover {
        background-color: #03d4f4; /* Mã màu xanh khi di chuột qua nút */
        color: #ffffff; /* Mã màu cho văn bản khi di chuột qua nút */
        border-color: #03d4f4; /* Mã màu xanh khi di chuột qua nút */
    }
	.custom-preview-color {
        background-color: #f47703; /* Mã màu xanh bạn muốn sử dụng cho nền */
        color: #ffffff; /* Mã màu cho văn bản */
        border-color: #f47703; /* Mã màu xanh bạn muốn sử dụng cho đường viền (border) */
    }

    .custom-preview-color:hover {
        background-color: #f7ac65; /* Mã màu xanh khi di chuột qua nút */
        color: #ffffff; /* Mã màu cho văn bản khi di chuột qua nút */
        border-color: #f7ac65; /* Mã màu xanh khi di chuột qua nút */
    }
	.custom-edit-color {
        background-color: #00a67d; /* Mã màu xanh bạn muốn sử dụng cho nền */
        color: #ffffff; /* Mã màu cho văn bản */
        border-color: #00a67d; /* Mã màu xanh bạn muốn sử dụng cho đường viền (border) */
    }

    .custom-edit-color:hover {
        background-color: #5ae6c3; /* Mã màu xanh khi di chuột qua nút */
        color: #ffffff; /* Mã màu cho văn bản khi di chuột qua nút */
        border-color: #5ae6c3; /* Mã màu xanh khi di chuột qua nút */
    }
	.custom-delete-color {
        background-color: #f52257; /* Mã màu xanh bạn muốn sử dụng cho nền */
        color: #ffffff; /* Mã màu cho văn bản */
        border-color: #f52257; /* Mã màu xanh bạn muốn sử dụng cho đường viền (border) */
    }

    .custom-delete-color:hover {
        background-color: #ff6699; /* Mã màu xanh khi di chuột qua nút */
        color: #ffffff; /* Mã màu cho văn bản khi di chuột qua nút */
        border-color: #ff6699; /* Mã màu xanh khi di chuột qua nút */
    }
</style>

<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-J1QK7MQ807"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-J1QK7MQ807');
</script>
<div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                      <div class="row">
                        <div class="col-md-12">
						<div class="portlet light bordered">
							<center><span>Currently we are supporting the <b><font color=red>mp4|ts|mkv|mov|avi</font></b> videos upload. If you get an error, please <b><font color=red>convert to MP4</font>, </b></span></center>
                                    </div>
                            <!-- Begin: life time stats -->
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                        <div class="caption" style="width: 75%;height: 33px;overflow: hidden;">
                                            <i class="fa fa-upload fa-lg font-red"></i>
                                            <span class="caption-subject font-red sbold uppercase">My video &nbsp;</span>
 
                                              <span class="caption-helper"> （You have a total of <?=$this->csdb->get_nums('vod',array('uid'=>$user->id))?> videos） </span>
 
                                        </div>
                                        <div class="actions">
                               <div class="btn-group">
                                            <a class="btn red btn-outline  btn-sm" href="javascript:;" data-toggle="dropdown" data-hover="dropdown" data-close-others="true" aria-expanded="false"> Browse mode
                                                <i class="fa fa-angle-down"></i>
                                            </a>
                                            <ul class="dropdown-menu pull-right">
                                                <li>
                                                  <a href="javascript:;"><i class="fa fa-check"></i> Detail mode</a>
                                                </li>
                                                <li class="divider"> </li>
                                                <li>
                                                    <a href="<?=links('vod','index','pic',$cid)?>"> Image mode</a>
                                                </li>
                                                
                                            </ul>
                                        </div>
                                                                    
                                                                    
                                        </div>
                                    </div>
                                    <div class="portlet-body">
                                        <div class="tabbable-line">
                                            <ul class="nav nav-tabs">
                                                <li<?php if($cid == 0) echo ' class="active"';?>><a href="<?=links('vod')?>">All videos</a></li>
                                                <?php 
                                                foreach($class as $row){
                                                    $cls = $cid == $row->id ? 'active' : '';
                                                    echo '<li class="'.$cls.'"><a href="'.links('vod','index',$op,$row->id).'">'.$row->name.'</a></li>';
                                                }
                                                ?>
										<div style="text-align: right;">
										<div><span><a href="<?=links('upload')?>" class="btn btn-sm btn-default custom-link-color">Upload Video</a></span></div></div>
    	                                    </ul>
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="overview_1">
                                                    <form class="layui-form" action="<?=site_url('vod/delAll')?>" method="post">
                                                    <table class="table table-striped table-hover table-bordered reponse-table">
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
                                                                <th> Thumbnail </th>
                                                                <th> Video name </th>
																<th> Capacity </th>
                                                                <th> Category </th>
																<th><a class="sortViews" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>"><font color="green">Views</font><i class="fa <?php echo $cssSort; ?>"></i><a></th>
                                                                <th> Status</th>
                                                                <th> Release time </th>
                                                                <th> Action </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <?php
                                                        if(empty($vod)) echo '<tr><td align="center" height="50" colspan="7">No related records</td></tr>';
                                                        $arr = array();
														foreach($vod as $k=>$row){
															if($row->fid > 0){
																$server = $this->csdb->get_row_arr('server','m3u8dir,cdnurl',array('id'=>$row->fid));
															}else{
																$server = array();
															}
                                                            $cname = $myname = ' -- ';
                                                            if($row->cid > 0) $cname = getzd('class','name',$row->cid);
                                                            if($row->mycid > 0) $myname = getzd('myclass','name',$row->mycid);
                                                            if($row->zt == 1){
                                                                $color = '';
                                                                $zt = '<span class="spinner-icon"><i class="fa fa-spinner fa-spin"></i>Transcoding</span>';
                                                            }elseif($row->zt == 2){
                                                                $color = 'color:#080;';
                                                                $zt = '<i class="fa fa-check-square-o"></i>Transcoded';
                                                            }elseif($row->zt == 3){
                                                                $color = 'color:red;';
                                                                $zt = '<i class="fa fa-window-close-o">Transcoding failed</i>';
                                                            }else{
                                                                $color = 'color:#f90;';
                                                                $zt = '<i class="fa fa-retweet"></i>To be transcoded';
                                                            }
                                                            $pic = $pic2 = '';
                                                            for($i = 1;$i<=Jpg_Num;$i++){
                                                                $piclink = m3u8_link($row->vid,$row->addtime,'pic',$i,$server);
                                                                $pic .= '<img alt="'.$row->name.'" src="'.$piclink.'">';
                                                                $pic2 .= $piclink.'</br>';
                                                            }
                                                            echo '
                                                            <tr>
                                                                <td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>
																<td><img class="lazy" src="'.m3u8_link($row->vid,$row->addtime,'pic',1,$server).'" style="height: 50px;width: 90px;"></td>
                                                                <td style="text-align: left;"><a href="'.links('play','index',$row->vid).'" target="_blank" title="'.$row->name.'">'.(mb_strlen($row->name) > 30 ? mb_substr($row->name, 0, 30) . '...' : $row->name).'</a></td>
																<td><span class="label label-info">'.formatsize($row->size).'</span>
                                                                <td>'.$cname.'</td>
																<td>'.$row->hits.'</td>
                                                                <td class="text-primary" style="'.$color.'">'.$zt.'</td>
                                                                <td>'.date('Y-m-d H:i:s',$row->addtime).'</td>
                                                                <td><a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard btn btn-sm btn-default custom-link-color"><i class="icon-note"></i> Link</a><a  href="'.links('play','index',$row->vid).'"  target="_blank" class="btn btn-sm btn-default custom-preview-color">  <i class="fa fa-search"></i> Preview</a><a href="'.links('vod','edit',$row->id).'" class="btn btn-sm btn-default custom-edit-color"><i class="fa fa-edit"></i> Edit</a><a  href="javascript:getajax(\''.links('vod','del',$row->id).'\',\'del\');" class="btn btn-sm btn-default custom-delete-color">  <i class="fa fa-remove"></i> Delete </a></td>
                                                            </tr>

                                                            <div id="long'.$row->id.'" class="modal fade" tabindex="-1" data-width="600">
                                                            <div class="modal-dialog" style="margin:0px;padding:0px;">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                                                                        <h4 class="modal-title">From '.$row->name.' preview</h4>
                                                                    </div>
                                                                    <div class="modal-body" style="height:120px" >
                                                                        '.$pic.' 
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="well" id="copyshare'.$row->id.'" style="margin-bottom: 0px;">'.$pic2.'</div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" href="javascript:;" data-clipboard-text="'.$pic2.' "  class="mt-clipboard btn btn-success copy-img">One-click copy</button>
                                                                        <button type="button" data-dismiss="modal" class="btn btn-primary">Close</button>
                                                                    </div>
                                                                </div>
                                                            </div>';
															$arr[$k]['name'] = $row->name;
															$arr[$k]['link'] = 'http://'.Web_Url.links('play','index',$row->vid);
															$arr[$k]['m3u8link'] = m3u8_link($row->vid,$row->addtime,'m3u8',$i,$server);
															
                                                        }
                                                        ?>
                                                        </tbody>
                                                    </table>
                                                    <div class="more_func">
                                                        <a class="layui-btn layui-btn-primary layui-btn-small" href="javascript:select_all();"><i class="fa fa-check colorl" ></i>Select All</a>
                                                        <a class="layui-btn layui-btn-primary layui-btn-small" lay-submit lay-filter="del_pl"><i class="fa fa-close " style="color: red" ></i>Delete selected</a>
                                                    </div>
                                                    </form>
                                                    <div class="row">
                                                        <div class="col-md-offset-4 col-md-8">
                                                            <ul class="pagination"  style="float:right">
                                                                <?=$pages?>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
<div id="longshare" class="modal fade in modal-overflow" aria-hidden="true" tabindex="-1" data-width="600" style="display: none;">
    <div class="modal-content" style="opacity: 1;">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h4 class="modal-title" id="myModalLabel">Get share address</h4>
        </div>
        <div class="modal-body">

            <div style="padding-top:5px;">
                <h5>Player address</h5>
                <div class="input-group" id="copy_caji">
                    <input type="text" class="form-control">
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy iframe</span>
                </div>
                <br>
                <div class="input-group" id="copy_wjmwz">
                    <input type="text" class="form-control">
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy direct link</span>
                </div>
            </div>
			<br>
				<div class="input-group" id="copy_m3u8">
                    <input type="text" class="form-control">
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy m3u8 link (only VIP)</span>
                </div>
            <div style="padding-top:20px;">
                <div class="alert alert-danger">
                    <b>Warning：</b>Please confirm that the file resources you share comply with relevant local laws and regulations, and know the responsibilities and risks you need to bear!
                </div>
                <div class="alert alert-danger">
                    <strong>Remind：</strong>The player (recommended) can realize automatic switching of failures, and perfectly supports H5 players; M3U8 cannot automatically migrate when a node fails!
                </div>
            </div>
        </div>
        <div class="modal-footer" style="padding:20px;">
            <a type="button" class="btn btn-default btn-sm" data-dismiss="modal">
                Close
            </a>
        </div>
    </div>
</div>
<script language="javascript">
var n = 0;
//File link code
var upl_array = <?=json_encode($arr)?>;
function get_mode(type){
  var file = upl_array[n];
  var line = '<iframe width="100%" height="100%" src="'+ file['link'] +'" frameborder="0" allowfullscreen></iframe>';
  $('#copy_caji input').val(line);
  $('#copy_caji .copy-btn').attr('data-clipboard-text',line);
  var line = file['link'];
  $('#copy_wjmwz input').val(line); 
  $('#copy_wjmwz .copy-btn').attr('data-clipboard-text',line);
  var line = file['m3u8link'];
  $('#copy_m3u8 input').val(line); 
  $('#copy_m3u8 .copy-btn').attr('data-clipboard-text',line);
}
$(document).ready(function() {
    var layer = layui.layer;
    $('#a3').addClass('active');
    $('.copy-btn').on('click', function () {
        var clipboard = new Clipboard('.copy-btn');
        clipboard.on('success', function(e) {
          layer.msg('Copy successfully');
        });
        clipboard.on('error', function(e) {
          layer.msg('Replication failed', {shift: 6});
        });
    })
    $('.copy-img').on('click', function () {
        var clipboard2 = new Clipboard('.copy-img');
        clipboard2.on('success', function(e) {
          layer.msg('Copy successfully');
        });
        clipboard2.on('error', function(e) {
          layer.msg('Replication failed', {shift: 6});
        });
    });


    $('.sortViews').click(function () {

        var link = $(this).attr('data-link');
        if($(this).attr('data-value') === 'desc') {
            link = link + '?sort_by=asc';
        } else {
            link = link + '?sort_by=desc';
        }
        window.location.href = link;
        
    });

});
</script>
