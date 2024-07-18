<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
    <head>
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layer/theme/default/layer.css">
		<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/modules/layer/default/layer.css">
		<script src="<?=Web_Path?>packs/layui/layui.js"></script>
		<style>.custom-link-color{background-color:#03a9f4;color:#fff;border-color:#03a9f4}.custom-link-color:hover{background-color:#03d4f4;color:#fff;border-color:#03d4f4}.custom-preview-color{background-color:#f47703;color:#fff;border-color:#f47703}.custom-preview-color:hover{background-color:#f7ac65;color:#fff;border-color:#f7ac65}.custom-edit-color{background-color:#00a67d;color:#fff;border-color:#00a67d}.custom-edit-color:hover{background-color:#5ae6c3;color:#fff;border-color:#5ae6c3}.custom-delete-color{background-color:#f52257;color:#fff;border-color:#f52257}.custom-delete-color:hover{background-color:#f69;color:#fff;border-color:#f69}.copy-btn{cursor:pointer;background-color:#4CAF50;color:#fff;border:1px solid #4CAF50}.thumbnail-img{transition:transform 0.3s ease-in-out}.enlarged-img{transform:scale(2);z-index:1}</style>
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
                                            <i class="fa fa-search fa-lg font-red"></i>
                                            <span class="caption-subject font-red sbold uppercase">Search Keywords: <?=$key?>&nbsp;</span>
                                              <span class="caption-helper"> （There are a total of <?=$nums?> videos matching the query） </span>
                                        </div>
                                    </div>
                                    <div class="portlet-body">
                                        <div class="tabbable-line">

                                            <div class="tab-content">
                                                <div class="tab-pane active" id="overview_1">
												<form class="layui-form" action="<?=site_url('vod/delAll')?>" method="post">
                                                    <table class="table table-striped table-hover table-bordered">
                                                        <thead>
																<th> Select </th>
                                                                <th> Thumbnail </th>
                                                                <th> Video name </th>
																<th> Capacity </th>
																<th> Durations </th>
                                                                <th> Category </th>
																<th> Views </th>
                                                                <th> Status</th>
                                                                <th> Release time </th>
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
                                                            $cname = ' -- ';
                                                            if($row->cid > 0) $cname = getzd('class','name',$row->cid);
                                                            if($row->zt == 1){
                                                                $color = '';
                                                                $zt = '<span class="spinner-icon"><i class="fa fa-circle-o-notch fa-spin"></i> Transcoding';
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
                                                            echo '
                                                            <tr>
																<td><input name="id['.$row->id.']" lay-ignore class="xuan" type="checkbox" value="'.$row->id.'" /></td>

																<td>'.$thumbImg.'</td>

                                                                <td style="text-align: left;"><a href="'.links('play','index',$row->vid).'" target="_blank" title="'.$row->name.'">'.(mb_strlen($row->name) > 30 ? mb_substr($row->name, 0, 30) . '...' : $row->name).'</a></td>
																<td><span class="label label-info">'.formatsize($row->size).'</span>
																<td><span class="label label-info">'.formattime($row->duration,1).'</span>
                                                                <td>'.$cname.'</td>
																<td>'.$row->hits.'</td> 
                                                                <td id="zm_'.$row->id.'" class="text-primary" style="'.$color.'">'.$zt.'</td>
                                                                <td>'.get_time($row->addtime).'</td>
                                                                <!--td><span id="copyid'.$row->id.'"> '.$row->vid.' </span>&nbsp;&nbsp;<a href="javascript:;" data-clipboard-action="copy" data-clipboard-target="#copyid'.$row->id.'" class="mt-clipboard btn btn-sm btn-default"><i class="icon-note"></i>Click copy</a></td-->
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
															$arr[$k]['link_backup'] = 'https://14412882.net/play/index/' . $row->vid;
															$arr[$k]['m3u8link'] = m3u8_link($row->vid,$row->addtime,'m3u8',$i,$server);
                                                        }
                                                        ?>
                                                        </tbody>
                                                    </table>
													<div class="more_func">
                                                        <a class="mt-clipboard btn btn-sm btn-default custom-link-color" href="javascript:select_all();"><i class="fa fa-check colorl" ></i> Select All</a>
                                                        <a class="btn btn-sm btn-default custom-delete-color" lay-submit lay-filter="del_pl"><i class="fa fa-remove" ></i> Delete selected</a>
                                                    </div>
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
							<div class="input-group" id="copy_iframe_backup">
                    <input type="text" class="form-control" readonly>
                    <span class="input-group-addon copy-btn" data-clipboard-text="">Copy iframe</span>
                </div>
				<br>
							<div class="input-group" id="copy_backup">
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
                    $("#zm_" + value.id).html('<font color=green><i class="fa fa-check-square-o"></i> Transcoded</font>');
                } else if (value.zt == 3) {
                    $("#zm_" + value.id).html('<font color=red>Transcoding failed</font>');
                }
            });
        }, 'json');
    }
}
$(document).ready(function() {
    
});
</script>

<script language="javascript">var n=0;var upl_array=<?=json_encode($arr)?>;function get_mode(type){var file=upl_array[n];var line='<iframe width="100%" height="100%" src="'+file.link+'" frameborder="0" allowfullscreen></iframe>';$('#copy_caji input').val(line);$('#copy_caji .copy-btn').attr('data-clipboard-text',line);var line='<iframe width="100%" height="100%" src="'+file.link_backup+'" frameborder="0" allowfullscreen></iframe>';$('#copy_iframe_backup input').val(line);$('#copy_iframe_backup .copy-btn').attr('data-clipboard-text',line);var line=file.link;$('#copy_wjmwz input').val(line);$('#copy_wjmwz .copy-btn').attr('data-clipboard-text',line);var line=file.images;$('#copy_images input').val(line);$('#copy_images .copy-btn').attr('data-clipboard-text',line);var line=file.link_backup;$('#copy_backup input').val(line);$('#copy_backup .copy-btn').attr('data-clipboard-text',line);var line=file.m3u8link;$('#copy_m3u8 input').val(line);$('#copy_m3u8 .copy-btn').attr('data-clipboard-text',line)}
$(document).ready(function(){var layer=layui.layer;$('#a3').addClass('active');$('.copy-btn').on('click',function(){var clipboard=new Clipboard('.copy-btn');clipboard.on('success',function(e){layer.msg('Copy successfully')});clipboard.on('error',function(e){layer.msg('Replication failed',{shift:6})})})
$('.copy-img').on('click',function(){var clipboard2=new Clipboard('.copy-img');clipboard2.on('success',function(e){layer.msg('Copy successfully')});clipboard2.on('error',function(e){layer.msg('Replication failed',{shift:6})})})});</script><script>document.addEventListener("DOMContentLoaded",function(){var thumbnailImages=document.querySelectorAll(".thumbnail-img");thumbnailImages.forEach(function(img){img.addEventListener("mouseenter",function(){img.classList.add("enlarged-img")});img.addEventListener("mouseleave",function(){img.classList.remove("enlarged-img")})})});</script>