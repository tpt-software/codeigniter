<!DOCTYPE html>
            <div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                      <div class="row">
                        <div class="col-md-12">
						<div class="portlet light bordered">
						<center><span style="font-size: 12px; color:red; font-weight: bold; text-transform: uppercase;"> Warning: Update new backup domain <a href="https://14412882.net" target="_blank">14412882.net</a>, please replace the new domain in your database, Thank you!</span></center>
                                    </div>
                            <!-- Begin: life time stats -->
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                        <div class="caption">
                                            <i class="fa fa-heart fa-lg font-blue"></i>
                                            <span class="caption-subject font-blue sbold uppercase">My collection &nbsp;</span>
                                            <span class="caption-helper"> （Your favorites in total <?=$this->csdb->get_nums('fav',array('uid'=>$user->id))?> department video） </span>
                                        </div>
                                    </div>
                                    <div class="portlet-body">
                                        <div class="tabbable-line">
                                            <ul class="nav nav-tabs">
                                                <li<?php if($cid == 0) echo ' class="active"';?>><a href="<?=links('fav')?>">All videos</a></li>
                                                <?php 
                                                foreach($class as $row){
                                                    $cls = $cid == $row->id ? 'active' : '';
                                                    echo '<li class="'.$cls.'"><a href="'.links('fav','index',$row->id).'">'.$row->name.'</a></li>';
                                                }
                                                ?>
    	                                    </ul>
                                            <div class="tab-content">
                                                <div class="tab-pane active" id="overview_1">
                                                    <table class="table table-striped table-hover table-bordered">
                                                        <thead>
                                                            <tr>
                                                                <th> Video name </th>
                                                                <th> Category </th>
                                                                <th> Status</th>
                                                                <th> Release time </th>
                                                                <th> Video ID </th>
                                                                <th> Action </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                        <?php
														$arr = array();$k = 0;
                                                        if(empty($vod)) echo '<tr><td align="center" height="50" colspan="7">No related records</td></tr>';
                                                        foreach($vod as $row2){
                                                            $row = $this->csdb->get_row('vod','*',array('id'=>$row2->did));
                                                            if($row){
																if($row->fid > 0){
																	$server = $this->csdb->get_row_arr('server','m3u8dir,cdnurl',array('id'=>$row->fid));
																}else{
																	$server = array();
																}
                                                                $cname = ' -- ';
                                                                if($row->cid > 0) $cname = getzd('class','name',$row->cid);
                                                                if($row->zt == 1){
                                                                    $color = 'color:#080;';
                                                                    $zt = '<i class="fa fa-spinner"></i>Transcoding';
                                                                }elseif($row->zt == 2){
                                                                    $color = '';
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
                                                                    $pic2 .= $piclink.'<br>';
                                                                }
                                                                echo '
                                                                <tr>
                                                                    <td style="text-align: left;"><a href="'.links('play','index',$row->vid).'" target="_blank">'.$row->name.'</a> <span class="label label-info">'.formatsize($row->size).'</span></td>
                                                                    <td>'.$cname.'</td>
                                                                    <td class="text-primary" style="'.$color.'">'.$zt.'</td>
                                                                    <td>'.get_time($row->addtime).'</td>
                                                                    <!--td><span id="copyid'.$row->id.'"> '.$row->vid.' </span>&nbsp;&nbsp;<a href="javascript:;" data-clipboard-action="copy" data-clipboard-target="#copyid'.$row->id.'" class="mt-clipboard btn btn-sm btn-default"><i class="icon-note"></i>Click to copy</a></td-->
																	<td><a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard btn btn-sm btn-default"><i class="icon-note"></i>Click to get share link</a></td>
																	<td><a href="#long'.$row->id.'" data-toggle="modal"  class="btn btn-sm btn-default"> <i class="fa fa-file-picture-o"></i> Preview </a><a  href="'.links('play','index',$row->vid).'"  target="_blank" class="btn btn-sm btn-default">  <i class="fa fa-search"></i> preview </a><a href="javascript:getajax(\''.links('ajax','delfav',$row2->id).'\',\'del\');" class="btn btn-sm btn-default"><i class="fa fa-remove"></i> cancel favorite </a></td>
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
																$k++;
                                                            }
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
			<h4 class="modal-title" id="myModalLabel">Off getting shared addresses closed</h4>
		</div>
		<div class="modal-body">
			<table align="center" width="100%" cellpadding="4" cellspacing="0" border="0" class="td_line">
				<tbody>
				<tr>
					<td>
						<div>Player (recommended): 
							<a href="javascript:void(0);" onclick="get_mode('fetch');">iframe</a> 
							- <a href="javascript:void(0);" onclick="get_mode('wnurl');">Direct link</a>
						</div>
						<div>M3U8: 
							<a href="javascript:void(0);" onclick="get_mode('m3u8');">[M3U8 Acquisition mode]</a>
							- <a href="javascript:void(0);" onclick="get_mode('m3u8url');">[M3U8 Filename and URL]</a>
						</div>
					</td>
				</tr>
				</tbody>
			</table>
			<div style="padding-top:5px;">
				<textarea id="link_area" style="width:100%; height:300px;"></textarea>
			</div>
			<div style="padding-top:20px;">
				<div class="alert alert-danger">
					  <strong>Warning:</strong>Please confirm that the file resources you share comply with relevant local laws and regulations, and know the responsibilities and risks you need to bear!
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
<script type="text/javascript">
var n = 0;
//File link code
var upl_array = <?=json_encode($arr)?>;
function get_mode(type){
	var file = upl_array[n];
	switch(type){
		case 'fetch':
			var line = file['name'] + '$' + file['link'];
		break;
		case 'm3u8':
			var line = file['name'] + '$' + file['m3u8'];
		break;
		case 'wnurl':
			var line = '['+file['name'] + ']: ' + file['link'];
		break;
		case 'm3u8url':
			var line = '['+file['name'] + ']: ' + file['m3u8'];
		break;
	}
	if(document.all){
		document.getElementById('link_area').innerText = line;
	}else{
		document.getElementById('link_area').innerHTML = line;
	}
}
$('#a5').addClass('active');
</script>