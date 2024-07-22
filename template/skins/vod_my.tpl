<?php 
function ma_hoa_chuoi($chuoi, $khoa) {
                                          $chuoi_ma_hoa = '';
                                          $khoa_length = strlen($khoa);
                                          for ($i = 0; $i < strlen($chuoi); $i++) {
                                           $chuoi_ma_hoa .= $chuoi[$i] ^ $khoa[$i % $khoa_length];
                                                }
                                            
                                                return bin2hex($chuoi_ma_hoa);
                                            }
$khoa = "zino_deptrai";
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
    <head>
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layer/theme/default/layer.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/admin/css/custom/vod_my.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/modules/layer/default/layer.css">
		<script src="<?=Web_Path?>packs/layui/layui.js"></script>
		<style>.custom-link-color{background-color:#03a9f4;color:#fff;border-color:#03a9f4}.custom-link-color:hover{background-color:#03d4f4;color:#fff;border-color:#03d4f4}.custom-preview-color{background-color:#f47703;color:#fff;border-color:#f47703}.custom-preview-color:hover{background-color:#f7ac65;color:#fff;border-color:#f7ac65}.custom-edit-color{background-color:#00a67d;color:#fff;border-color:#00a67d}.custom-edit-color:hover{background-color:#5ae6c3;color:#fff;border-color:}.custom-delete-color{background-color:#f52257;color:#fff;border-color:#f52257}.custom-delete-color:hover{background-color:#f69;color:#fff;border-color:#f69}.copy-btn{cursor:pointer;background-color:#4CAF50;color:#fff;border:1px solid #4CAF50}.copy-btn-not{cursor:not-allowed;background-color:#4CAF50;color:#fff;border:1px solid #4CAF50}</style>
</head>
<body>
<div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                      <div class="row">
                        <div class="col-md-12">
						<div class="portlet light bordered">
						<center><span style="font-size: 12px; color:red; font-weight: bold; text-transform: uppercase;">Warning: Update new backup domain <a href="https://14412882.com" target="_blank">14412882.com</a>, please replace the new domain in your database, Thank you!</span></div></center>
                                    </div>
                            <!-- Begin: life time stats -->
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                        <div class="caption" style="width: 75%;height: 33px;overflow: hidden;">
                                            <i class="fa fa-folder-open fa-lg font-red"></i>
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
									<div class="portlet light bordered">
										<center><span style="font-size: 14px; font-weight: bold;">Please wait 15 - 30 minutes after upload for video rendering to complete. If your previous visit had a cached playback error, please clear your browser's cache or use <span style="color: red;">Ctrl + F5</span></span></center>
									</div>
                                    <div class="portlet-body">
                                        <div class="tabbable-line">
                                            <ul class="nav nav-tabs">
                                                <li<?php if($cid == 0) echo ' class="active"';?>><a href="<?=links('vod')?>">All videos</a></li>
                                                <?php 
                                                foreach($class as $index => $name){
                                                    $cls = $cid == $index ? 'active' : '';
                                                    echo '<li class="'.$cls.'"><a href="'.links('vod','index',$op,$index).'">'.$name.'</a></li>';
                                                }
                                                ?>
										<div style="text-align: right;">
                                        
										<div>
                                        <span><a href="<?=links('folder', 'edit')?>" class="btn btn-sm btn-default custom-link-color">Add Folder</a></span>
                                        <span><button  data-toggle="modal" data-target="#modal-move-folder"  class="btn btn-sm btn-default custom-link-color move-folder-a-click">Move Folder</button></span>
                                        <span><a href="<?=links('upload')?>" class="btn btn-sm btn-default custom-link-color">Upload Video</a></span>
                                        </div></div>
    	                                    </ul>
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="overview_1">
                                                    <form class="layui-form" action="<?=site_url('vod/delAll')?>" method="post">
                                                    <table class="table table-striped table-hover table-bordered reponse-table">
													<div class="more_func">
													   <div class="pull-right">
                                                         <a class="btn btn-sm btn-default custom-delete-color" lay-submit lay-filter="del_pl"><i class="fa fa-remove" ></i> Delete selected</a>
													   </div>
														 <a class="btn btn-sm btn-default" style="background: #03a9f4; color: #fff;"><i class="fa fa-bars"></i> Export link selected</a>
                                                    </div>
													<br>
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
                                                                <th><a class="mt-clipboard" href="javascript:select_all();">Select all</a></th> 
                                                                <th> Thumbnail </th> 
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Video name</span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-video_name" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-video_name" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th>
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Capacity</span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-capacity" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-capacity" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th> 
																<th> Durations </th>																
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Category &nbsp</span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-category" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-category" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th>
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Views &nbsp</span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-views" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-views" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th> 
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Status </span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-status" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-status" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th>  
                                                                <th> 
                                                                    <a class="sortViews th-header" href="javascript:void(0)" data-value="<?php echo $sBy; ?>" data-link="<?php echo links('vod', 'index', $op, $cid); ?>">
                                                                        <span>Release time </span>
                                                                        <span class="container-sort">
                                                                            <i id="asc-icon-release_time" class="fa fa-sort-asc" aria-hidden="true"></i>
                                                                            <i id="desc-icon-release_time" class="fa fa-sort-desc" aria-hidden="true"></i>
                                                                        </span> 
                                                                    <a>
                                                                </th>   
                                                                <th> Action </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <?php
														
                                                        if(empty($vod)) echo '<tr><td align="center" height="50" colspan="7">No related records</td></tr>';
                                                        $arr = array();
														foreach($vod as $k=>$row){
															if($row->fid > 0){
                                                                if (array_key_exists($row->fid, $servers)) {
                                                                    $server = $servers[$row->fid];
                                                                } else {
                                                                    $server = array();
                                                                }
															}else{
																$server = array();
															}
                                                            $cname = $myname = ' -- ';
                                                            
                                                            if($row->cid > 0) {
                                                                if (array_key_exists($row->cid, $class)) {
                                                                    $cname = $class[$row->cid];
                                                                } else {
                                                                    $cname = '';
                                                                }
                                                            }
														
                                                            if($row->mycid > 0) {
                                                                if (array_key_exists($row->mycid, $myclass)) {
                                                                    $myname = $myclass[$row->mycid];
                                                                } else {
                                                                    $myname = '';
                                                                }
                                                            }
                                                            $visble_link_video = false;
                                                            if($row->zt == 1){
                                                                $visble_link_video =false;
                                                                $color = '';
                                                                $zt = '<span class="spinner-icon"><i class="fa fa-circle-o-notch fa-spin"></i> Transcoding...</span>';
                                                            }elseif($row->zt == 2){
                                                               $current_time = time(); 

                                                                $difference = $current_time - (int) $row->addtime;

                                                                if ($difference < 300) {
                                                                    $zt = '<font color=orange><i class="fa fa-spinner fa-spin"></i> processing</font>';
                                                                } else {
                                                                    $visble_link_video =true;
                                                                    $zt = '<font color=green><i class="fa fa-check-square-o"></i> Transcoded</font>';
                                                                }
                                                            }elseif($row->zt == 3){
                                                                $visble_link_video =false;
                                                                $color = 'color:red;';
                                                                $zt = '<i class="fa fa-window-close-o"> Transcoding failed</i>';
                                                            }else{
                                                                $visble_link_video =false;
                                                                $color = 'color:#f90;';
                                                                $zt = '<i class="fa fa-retweet"></i> To be transcoded';
                                                            }
                                                            
                                                            if ($row->is_remote_m3u8) {
                                                                $pic = $pic2 = '';
                                                                for($i = 1;$i<=Jpg_Num;$i++){
                                                                    $piclink = $row->thumnail_url;
                                                                    $pic .= '<img alt="'.$row->name.'" src="'.$piclink.'">';
                                                                    $pic2 .= $piclink.'</br>';
                                                                }
                                                                $thumbImg = '<img class="lazy" src="'.$row->thumnail_url.'" style="height: 50px;width: 90px;">';
                                                            } else {
                                                                $pic = $pic2 = '';
                                                                for($i = 1;$i<=Jpg_Num;$i++){
                                                                    $piclink = m3u8_link($row->vid,$row->addtime,'pic',$i,$server);
                                                                    $pic .= '<img alt="'.$row->name.'" src="'.$piclink.'">';
                                                                    $pic2 .= $piclink.'</br>';
                                                                }
                                                                $thumbImg = '<img class="lazy" src="'.m3u8_link($row->vid,$row->addtime,'pic',1,$server).'" style="height: 50px;width: 90px;">';
                                                            }
															$name = $row->name; 
                                                            if (mb_strlen($name) > 30) {
                                                                $name = mb_substr($name, 0, 30) . '...';
                                                            }
                                                            $icon = '';
                                                            if($row->type == 'video'){
                                                                $icon = '<i class="fa fa-video-camera" aria-hidden="true" style="color: #FFD43B;font-size: 19px;"></i>';
                                                                $link = links('play','index',$row->vid);
                                                                $linkEdit = links('vod','edit',$row->vid);
                                                                $linkDel = links('vod','del',$row->id);
                                                                $thumbImg =  $thumbImg;
                                                                $href = "javascript:getajax('".$linkDel."', 'del')";
                                                                $editVideo = ' <a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard btn btn-sm btn-default custom-link-color">
                                                                    <i class="icon-note"></i> Link
                                                                </a>
                                                                <a  href="'.$link.'"  target="_blank" class="btn btn-sm btn-default custom-preview-color">
                                                                    <i class="fa fa-search"></i> Preview
                                                                </a>';           
                                                            }else{
                                                                $icon = '<i class="fa fa-folder fa-2" style="color: #FFD43B;font-size: 19px;"></i>';
                                                                $link = '/folder/index/'. $row->id;
                                                                $linkEdit = links('folder','edit',$row->id);
                                                                $linkDel = links('folder','del',$row->id);
                                                                $thumbImg = $icon;
                                                                $href = "javascript:getajax('" . $linkDel . "', 'del', 'If you delete the Folder, all videos inside will be deleted and cannot be restored')";
                                                                $editVideo = '';
                                                            }
                                                            if( $visble_link_video == false){
                                                                $link = 'javascript:;';
                                                            }
                                                      
															$html = '
                                                            <tr class="video-item">
																<td>
																<input name="id['.$row->id.']" 
																lay-ignore class="xuan video-checkbox" 
																type="checkbox" 
																value="'.$row->id.'"  
																data-row="'.htmlspecialchars(json_encode($row)).'"      
																data-cname="'.$cname.'"      
																data-zt="'.$row->zt.'">
																</td>
                                                                <td>'.$thumbImg.'</td>
																
                                                                <td style="text-align: left;"><a href="'.$link.'" target="_blank" title="'.$row->name.'">'.$icon.$name.'</a></td>
																<td><span class="label label-info">'.formatsize($row->size).'</span>
																<td><span class="label label-info">'.formattime((int)$row->duration,1).'</span></td>
                                                                <td>'.$cname.'</td>
																<td>'.$row->hits.'</td> 
                                                                <td id="zm_'.$row->id.'" class="text-primary" style="'.$color.'">'.$zt.'</td>
                                                                <td>'.date('d-m-Y | H:i:s',$row->addtime).'</td>
                                                                <td>'.$editVideo.'

                                                                <a href="'.$linkEdit.'" class="btn btn-sm btn-default custom-edit-color">
                                                                    <i class="fa fa-edit"></i> Edit</a>
                                                                <a  href="'.$href.';" class="btn btn-sm btn-default custom-delete-color">
                                                                    <i class="fa fa-remove"></i> Delete 
                                                                </a>
                                                                </td>
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
															echo $html;
															$arr[$k]['name'] = $row->name;
															$arr[$k]['vip'] = 'https://14412882.com/vip/index/' . $row->vid;
															$arr[$k]['link'] = 'http://'.Web_Url.links('play','index',$row->vid);
															$arr[$k]['link_backup'] = 'https://14412882.com/play/index/' . $row->vid;
															$m3u8_url = m3u8_link($row->vid,$row->addtime,'m3u8',$i,$server);
															$arr[$k]['m3u8link'] = 'http://' . $_SERVER['HTTP_HOST'] .'/hash.php?hash='.ma_hoa_chuoi($m3u8_url, $khoa).''; //ma_hoa_chuoi(m3u8_link($row->vid,$row->addtime,'m3u8',$i,$server), $khoa); 
															$images_url = m3u8_link($row->vid,$row->addtime,'pic',1,$server);
															$arr[$k]['images'] = $images_url;
															
                                                        }
                                                        ?>
                                                        </tbody>
                                                    </table>
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
                <h5>List Folder</h5>
                
				<div class="input-group" id="copy_iframe_backup">
                    <input type="text" class="form-control" readonly>
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy iframe</span>
                </div>
				<br>
            </div>
                
			<div class="input-group" id="copy_backup">
                    <input type="text" class="form-control" readonly>
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy direct link</span>
                </div>

				<br>
				<div class="input-group" id="copy_if_vip">
                <input type="text" class="form-control" readonly>
                <span class="input-group-addon copy-btn" data-clipboard-text="">Copy VIP iframe (only VIP)</span>
            </div>
			<br>
			<div class="input-group" id="copy_vip">
                <input type="text" class="form-control" readonly>
                <span class="input-group-addon copy-btn" data-clipboard-text="">Copy VIP direct (only VIP)</span>
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

<div id="modal-move-folder" class="modal fade in modal-overflow" aria-hidden="true" tabindex="-1" data-width="600" style="display: none;">
    <form action="<?=links('folder','move')?>" method="post" class="modal-content layui-form form-horizontal" style="opacity: 1;">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h4 class="modal-title" id="myModalLabel">Move folder</h4>
        </div>
        <div class="modal-body">

            <div style="padding-top:5px;">
                <h5>Player address</h5>
                <input type="hidden" name="video_id" id="video_id_array">
                <?php
                    foreach($folders as $folder){
                        echo'
				        <div class="input-group" id="copy_iframe_backup">
                            <input type="radio" class="video-checkbox" title="move to" name="folder_id" value="'.$folder->id.'">
                            <i class="fa fa-folder fa-2" style="color: #FFD43B;margin-left: 10px;" aria-hidden="true"></i>
                            <span class="copy-btn" data-clipboard-text="" style="margin-left: 5px;">'.$folder->name.'</span>
                        </div>';
                    }
                ?>    
				<br>
            </div>
                
        </div>
        <div class="modal-footer" style="padding:20px;">
            <button type="submit" lay-submit lay-filter="*" class="btn btn-primary btn-sm" data-dismiss="modal">
                Move
            </button>
            <a class="btn btn-default btn-sm" data-dismiss="modal">
                Close
            </a>
        </div>
    </form>
</div>
<script src="/packs/admin/js/vod.js" defer charset="UTF-8"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.4/xlsx.full.min.js" defer></script>
<script language="javascript">var n=0;var upl_array=<?=json_encode($arr)?>;function get_mode(type){var file=upl_array[n];var line=file.vip;$('#copy_vip input').val(line);$('#copy_vip .copy-btn').attr('data-clipboard-text',line);var line='<iframe width="100%" height="100%" src="'+file.vip+'" frameborder="0" allowfullscreen></iframe>';$('#copy_if_vip input').val(line);$('#copy_if_vip .copy-btn').attr('data-clipboard-text',line);var line='<iframe width="100%" height="100%" src="'+file.link_backup+'" frameborder="0" allowfullscreen></iframe>';$('#copy_iframe_backup input').val(line);$('#copy_iframe_backup .copy-btn').attr('data-clipboard-text',line);var line=file.images;$('#copy_images input').val(line);$('#copy_images .copy-btn').attr('data-clipboard-text',line);var line=file.link_backup;$('#copy_backup input').val(line);$('#copy_backup .copy-btn').attr('data-clipboard-text',line);var line=file.m3u8link;$('#copy_m3u8 input').val(line);$('#copy_m3u8 .copy-btn').attr('data-clipboard-text',line)}
$(document).ready(function(){var layer=layui.layer;$('#a3').addClass('active');$('.copy-btn').on('click',function(){var clipboard=new Clipboard('.copy-btn');clipboard.on('success',function(e){layer.msg('Copy successfully')});clipboard.on('error',function(e){layer.msg('Replication failed',{shift:6})})})
$('.copy-img').on('click',function(){var clipboard2=new Clipboard('.copy-img');clipboard2.on('success',function(e){layer.msg('Copy successfully')});clipboard2.on('error',function(e){layer.msg('Replication failed',{shift:6})})});$('.sortViews').click(function(){let link=$(this).attr('data-link');let title=$(this).closest('th').text().trim().replace(/ /g,'_').toLowerCase();if($(this).attr('data-value')==='desc'){link=link+'?sort_by=asc&title='+title}else{link=link+'?sort_by=desc&title='+title}
window.location.href=link})});$('.container-sort i').click(function(){$(this).addClass('active').siblings().removeClass('active');var title=$(this).closest('th').find('span:first').text().trim().replace(/ /g,'_').toLowerCase();var link='/vod/index'
if($(this).hasClass('fa-sort-asc')){link=link+'?sort_by=asc&title='+title}else{link=link+'?sort_by=desc&title='+title}
window.location.href=link});</script><script>var copyM3U8=document.getElementById('copy_m3u8');if (copyM3U8) {
	copyM3U8.addEventListener('keydown',function(event){if(event.ctrlKey&&(event.key==='c'||event.key==='C')){event.preventDefault()}});copyM3U8.addEventListener('contextmenu',function(event){event.preventDefault()});copyM3U8.addEventListener('copy',function(event){event.preventDefault()});
}</script><script>document.addEventListener("DOMContentLoaded",function(){var thumbnailImages=document.querySelectorAll(".thumbnail-img");thumbnailImages.forEach(function(img){img.addEventListener("mouseenter",function(){img.classList.add("enlarged-img")});img.addEventListener("mouseleave",function(){img.classList.remove("enlarged-img")})})});</script><script>document.addEventListener('DOMContentLoaded',function(){var iframe=document.querySelector('iframe');if (iframe) {
	iframe.onload = function() {
		gtag('event', 'video_play', {
			'event_category': 'Video',
			'event_label': 'Video_Played',
			'event_value': 1
		})
	}
}});</script><script>document.addEventListener('DOMContentLoaded',function(){let isDragging=!1;let startY=0;let lastEntered=null;let animationFrameId=null;const videoTable=document.querySelector('.table.table-striped.table-hover.table-bordered');videoTable.addEventListener('mousedown',function(e){if(!e.target.classList.contains('video-checkbox')){isDragging=!0;startY=e.clientY;e.preventDefault();requestAutoScroll()}});document.addEventListener('mousemove',function(e){if(isDragging){startY=e.clientY;toggleVideoSelectionUnderCursor(e)}});document.addEventListener('mouseup',function(){isDragging=!1;cancelAnimationFrame(animationFrameId)});function toggleVideoSelectionUnderCursor(e){const videoItem=findParentVideoItem(e.target);if(videoItem&&videoItem!==lastEntered){toggleVideoSelection(videoItem);lastEntered=videoItem}}
function findParentVideoItem(element){while(element&&!element.classList.contains('video-item')){element=element.parentElement}
return element}
function toggleVideoSelection(videoItem){const checkbox=videoItem.querySelector('.video-checkbox');checkbox.checked=!checkbox.checked}
function requestAutoScroll(){animationFrameId=requestAnimationFrame(autoScroll)}
function autoScroll(){const threshold=100;const maxSpeed=5;if(startY<threshold){window.scrollBy(0,-maxSpeed)}else if(window.innerHeight-startY<threshold){window.scrollBy(0,maxSpeed)}
if(isDragging){requestAutoScroll()}}});</script>
<script>
function get_zt() {
    var a = $(".xuan");
    var v = [];
    for (var n = 0; n < a.length; n++) {
        v.push(a[n].value);
    }
    if (v.length) {
        $.post('<?=links('vod','ajax')?>', {
            did: v.join(',')
        }, function(d) {
            d.forEach(function(value, i) {
                if (d[i].zt == 1) {
                    $("#zm_" + value.id).html('<font color=#1e9fff><span class="spinner-icon"><i class="fa fa-spinner fa-spin"></i>Transcoding...</span></font>');
                } else if (value.zt == 2) {
                    let currentTime = Math.floor(Date.now() / 1000);
                    let difference = currentTime - parseInt(value.addtime);
                    if (difference < 300) {
                        $("#zm_" + value.id).html('<font color=orange><i class="fa fa-spinner fa-spin"></i> processing</font>');
                    } else {
                       $("#zm_" + value.id).html('<font color=green><i class="fa fa-check-square-o"></i> Transcoded</font>');
                    }
                } else if (value.zt == 3) {
                    $("#zm_" + value.id).html('<font color=red>Transcoding failed</font>');
                }
            });
        }, 'json');
    }
}
$(document).ready(function() {
   $('.move-folder-a-click').on('click', function(){
        var xuanArray = [];

        $('.xuan').each(function() {
            if ($(this).is(':checked')) {
                var value = $(this).val();
                xuanArray.push(value);
            }
        });
        $('#video_id_array').val(xuanArray);
   })

setInterval("get_zt()",5000);
                console.log(123);

});
</script>
</body>
</html>
