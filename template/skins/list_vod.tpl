<!DOCTYPE html>
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
	
	.copy-btn {
	cursor: pointer;
	background-color: #4CAF50; /* Màu xanh lá */
    color: #fff; /* Màu chữ trắng */
    border: 1px solid #4CAF50; /* Viền màu xanh lá */
	}
</style>
</head>
            <div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                      <div class="row">
                        <div class="col-md-12">
                            <!-- Begin: life time stats -->
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                        <div class="caption">
										<a href="<?=links('lists')?>"><span><i class="fa fa-arrow-left font-blue"></i> <strong>Back</strong></span></a>
										<br>
										<br>
                                            <span class="caption-subject font-blue sbold uppercase">（<?=$list->name?>）Videos under categories &nbsp;</span>
                                              <span class="caption-helper"> （There are a total of <?=$nums?> videos in this category） </span>
                                        </div>
                                    </div>
                                    <div class="portlet-body">
                                        <div class="tabbable-line">
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="overview_1">
												<form class="layui-form" action="<?=site_url('vod/delAll')?>" method="post">
                                                    <table class="table table-striped table-hover table-bordered">
													<div class="more_func">
													   <div class="pull-right">
                                                         <a class="btn btn-sm btn-default custom-delete-color" lay-submit lay-filter="del_pl"><i class="fa fa-remove" ></i> Delete selected</a>
													   </div>
														 <a class="btn btn-sm btn-default" style="background: #03a9f4; color: #fff;" onclick="handleLinkChoose()"><i class="fa fa-bars"></i> Export link selected</a>
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
														$arr = array();
                                                        if(empty($vod)) echo '<tr><td align="center" height="50" colspan="7">No related records</td></tr>';
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
                                                                $color = 'color:#080;';
                                                                $zt = '<i class="fa fa-spinner"></i>Transcoding';
                                                            }elseif($row->zt == 2){
                                                                $color = 'color:#080;';
                                                                $zt = '<i class="fa fa-check-square-o"></i> Transcoded';
                                                            }elseif($row->zt == 3){
                                                                $color = 'color:red;';
                                                                $zt = '<i class="fa fa-window-close-o"> Transcoding failed</i>';
                                                            }else{
                                                                $color = 'color:#f90;';
                                                                $zt = '<i class="fa fa-retweet"></i> To be transcoded';
                                                            }
                                                            $pic = $pic2 = '';
                                                            for($i = 1;$i<=Jpg_Num;$i++){
                                                                $piclink = m3u8_link($row->vid,$row->addtime,'pic',$i,$server);
                                                                $pic .= '<img alt="'.$row->name.'" src="'.$piclink.'">';
                                                                $pic2 .= $piclink.'<br>';
                                                            }
                                                            echo '
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
																<td><img class="lazy" src="'.m3u8_link($row->vid,$row->addtime,'pic',1,$server).'" style="height: 50px;width: 90px;"></td>
                                                                <td style="text-align: left;"><a href="'.links('play','index',$row->vid).'" target="_blank" title="'.$row->name.'">'.(mb_strlen($row->name) > 30 ? mb_substr($row->name, 0, 30) . '...' : $row->name).'</a></td>
																<td><span class="label label-info">'.formatsize($row->size).'</span>
																<td><span class="label label-info">'.formattime($row->duration,1).'</span>
                                                                <td>'.$cname.'</td>
																<td>'.$row->hits.'</td> 
                                                                <td class="text-primary" style="'.$color.'">'.$zt.'</td>
                                                                <td>'.date('d-m-Y | H:i:s',$row->addtime).'</td>
                                                                <td><a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard btn btn-sm btn-default custom-link-color"><i class="icon-note"></i> Link</a><a  href="'.links('play','index',$row->vid).'"  target="_blank" class="btn btn-sm btn-default custom-preview-color">  <i class="fa fa-search"></i> Preview</a><a href="'.links('vod','edit',$row->id).'" class="btn btn-sm btn-default custom-edit-color"><i class="fa fa-edit"></i> Edit</a><a  href="javascript:getajax(\''.links('vod','del',$row->id).'\',\'del\');" class="btn btn-sm btn-default custom-delete-color">  <i class="fa fa-remove"></i> Delete </a></td>
                                                            </tr>
                                                            <div id="long'.$row->id.'" class="modal fade" tabindex="-1" data-width="600">
                                                            <div class="modal-dialog" style="margin:0px;padding:0px;">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                                                                        <h4 class="modal-title">From '.$row->name.' preview</h4>
                                                                    </div>
                                                                    <div class="modal-body" style="height:350px" >
                                                                        '.$pic.' 
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <div class="well" id="copyshare'.$row->id.'" style="margin-bottom: 0px;">'.$pic2.'</div>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" href="javascript:;" data-clipboard-action="copy" data-clipboard-target="#copyshare'.$row->id.'"  class="mt-clipboard btn btn-success">One-click copy</button>
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
			<table align="center" width="100%" cellpadding="4" cellspacing="0" border="0" class="td_line">
				<tbody>
				<tr>
					<td>
						<div>Player (recommended): 
							<div class="input-group" id="copy_caji">
                    <input type="text" class="form-control" readonly>
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy iframe</span>
                </div>
				<br>
							<div class="input-group" id="copy_wjmwz">
                    <input type="text" class="form-control" readonly>
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy direct link</span>
                </div>
						</div>
					</td>
				</tr>
				</tbody>
			</table>
			<div style="padding-top:20px;">
				<div class="alert alert-danger">
					  <strong>Warning:</strong>Please confirm that the file resources you share comply with relevant local laws and regulations, and know the responsibilities and risks you need to bear!
				</div>
				<div class="alert alert-danger">
					  <strong>Remind:</strong>The player (recommended) can realize automatic switching of failures, and perfectly supports H5 players; M3U8 cannot automatically migrate when a node fails!
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
<script src="/packs/admin/js/vod.js"  charset="UTF-8"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.4/xlsx.full.min.js"></script>
<script language="javascript">var n=0;var upl_array=<?=json_encode($arr)?>;function get_mode(type){var file=upl_array[n];var line=file.vip;$('#copy_vip input').val(line);$('#copy_vip .copy-btn').attr('data-clipboard-text',line);var line='<iframe width="100%" height="100%" src="'+file.vip+'" frameborder="0" allowfullscreen></iframe>';$('#copy_if_vip input').val(line);$('#copy_if_vip .copy-btn').attr('data-clipboard-text',line);var line='<iframe width="100%" height="100%" src="'+file.link_backup+'" frameborder="0" allowfullscreen></iframe>';$('#copy_iframe_backup input').val(line);$('#copy_iframe_backup .copy-btn').attr('data-clipboard-text',line);var line=file.images;$('#copy_images input').val(line);$('#copy_images .copy-btn').attr('data-clipboard-text',line);var line=file.link_backup;$('#copy_backup input').val(line);$('#copy_backup .copy-btn').attr('data-clipboard-text',line);var line=file.m3u8link;$('#copy_m3u8 input').val(line);$('#copy_m3u8 .copy-btn').attr('data-clipboard-text',line)}
$(document).ready(function(){var layer=layui.layer;$('#a3').addClass('active');$('.copy-btn').on('click',function(){var clipboard=new Clipboard('.copy-btn');clipboard.on('success',function(e){layer.msg('Copy successfully')});clipboard.on('error',function(e){layer.msg('Replication failed',{shift:6})})})
$('.copy-img').on('click',function(){var clipboard2=new Clipboard('.copy-img');clipboard2.on('success',function(e){layer.msg('Copy successfully')});clipboard2.on('error',function(e){layer.msg('Replication failed',{shift:6})})});$('.sortViews').click(function(){let link=$(this).attr('data-link');let title=$(this).closest('th').text().trim().replace(/ /g,'_').toLowerCase();if($(this).attr('data-value')==='desc'){link=link+'?sort_by=asc&title='+title}else{link=link+'?sort_by=desc&title='+title}
window.location.href=link})});$('.container-sort i').click(function(){$(this).addClass('active').siblings().removeClass('active');var title=$(this).closest('th').find('span:first').text().trim().replace(/ /g,'_').toLowerCase();var link='/vod/index'
if($(this).hasClass('fa-sort-asc')){link=link+'?sort_by=asc&title='+title}else{link=link+'?sort_by=desc&title='+title}
window.location.href=link});</script><script>var copyM3U8=document.getElementById('copy_m3u8');copyM3U8.addEventListener('keydown',function(event){if(event.ctrlKey&&(event.key==='c'||event.key==='C')){event.preventDefault()}});copyM3U8.addEventListener('contextmenu',function(event){event.preventDefault()});copyM3U8.addEventListener('copy',function(event){event.preventDefault()});</script><script>document.addEventListener("DOMContentLoaded",function(){var thumbnailImages=document.querySelectorAll(".thumbnail-img");thumbnailImages.forEach(function(img){img.addEventListener("mouseenter",function(){img.classList.add("enlarged-img")});img.addEventListener("mouseleave",function(){img.classList.remove("enlarged-img")})})});</script><script>document.addEventListener('DOMContentLoaded',function(){var iframe=document.querySelector('iframe');iframe.onload=function(){gtag('event','video_play',{'event_category':'Video','event_label':'Video_Played','event_value':1})}});</script><script>document.addEventListener('DOMContentLoaded',function(){let isDragging=!1;let startY=0;let lastEntered=null;let animationFrameId=null;const videoTable=document.querySelector('.table.table-striped.table-hover.table-bordered');videoTable.addEventListener('mousedown',function(e){if(!e.target.classList.contains('video-checkbox')){isDragging=!0;startY=e.clientY;e.preventDefault();requestAutoScroll()}});document.addEventListener('mousemove',function(e){if(isDragging){startY=e.clientY;toggleVideoSelectionUnderCursor(e)}});document.addEventListener('mouseup',function(){isDragging=!1;cancelAnimationFrame(animationFrameId)});function toggleVideoSelectionUnderCursor(e){const videoItem=findParentVideoItem(e.target);if(videoItem&&videoItem!==lastEntered){toggleVideoSelection(videoItem);lastEntered=videoItem}}
function findParentVideoItem(element){while(element&&!element.classList.contains('video-item')){element=element.parentElement}
return element}
function toggleVideoSelection(videoItem){const checkbox=videoItem.querySelector('.video-checkbox');checkbox.checked=!checkbox.checked}
function requestAutoScroll(){animationFrameId=requestAnimationFrame(autoScroll)}
function autoScroll(){const threshold=100;const maxSpeed=5;if(startY<threshold){window.scrollBy(0,-maxSpeed)}else if(window.innerHeight-startY<threshold){window.scrollBy(0,maxSpeed)}
if(isDragging){requestAutoScroll()}}});</script>