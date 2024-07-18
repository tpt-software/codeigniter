<!DOCTYPE html>
<style>
    .mt-element-card .mt-card-item .mt-card-content .mt-card-social ul li a{font-size:14px;color:#678098;} 
    .video-time {
    position: absolute;
    left: 0;
    bottom: 0;
    height: 38px;
    line-height: 41px;
    overflow: hidden;
    width: 100%;
    padding: 0 5%;
    color: #fff;
    font-size: 13px;
    background: url(/packs/assets/img/shadow4.png) repeat-x 0 1px;
    z-index: 10;
}
    .mt-element-card .mt-card-item .mt-card-content .mt-card-social ul li a:hover{color: #5b9bd1;text-decoration: none;}
     .modal-body img{
        float:left;
        display:block;
        width:180px;
        height:100px;
        margin: 3px;
        }
    .clear{clear:both}
  .oneline{overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    width: 95%;}
    </style>
            <div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                      <div class="row">
                        <div class="col-md-12">
                            <!-- Begin: life time stats -->
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                        <div class="caption" style="width: 75%;height: 33px;overflow: hidden;">
                                            <i class="fa fa-folder-open fa-lg font-blue"></i>
                                            <span class="caption-subject font-blue sbold uppercase">Video Square &nbsp;</span>
                                            <span class="caption-helper"> （This column is uploaded cumulatively <?=$this->csdb->get_nums('vod',array('cid'=>$cid))?> videos） </span>
                                        </div>
                                        <div class="actions">
                                        	
                                    </div>
                    
                                <div class="portlet-body">
                                   <div class="tabbable-line">
                                        <ul class="nav nav-tabs">
                                            <?php 
                                            foreach($class as $row){
                                                $cls = $cid == $row->id ? 'active' : '';
                                                echo '<li class="'.$cls.'"><a href="'.links('vod','square',$op,$row->id).'">'.$row->name.'</a></li>';
                                            }
                                            ?>
	                                    </ul>
                                        <div class="tab-content">
                                        <div class="portlet-body dataTables_wrapper">
                                            <div class="mt-element-card mt-element-overlay">
                                            <?php
											$arr = array();
                                            if(empty($vod)) echo '<p style="text-align: center;height: 50px;">No related records</p>';
                                            foreach($vod as $k=>$row){
												if($row->fid > 0){
													$server = $this->csdb->get_row_arr('server','m3u8dir,cdnurl',array('id'=>$row->fid));
												}else{
													$server = array();
												}
                                                $cname = ' Uncategorized ';
                                                if($row->cid > 0) $cname = getzd('class','name',$row->cid);
                                                $pic = $pic2 = '';
                                                for($i = 1;$i<=Jpg_Num;$i++){
                                                    $piclink = m3u8_link($row->vid,$row->addtime,'pic',$i,$server);
                                                    $pic .= '<img alt="'.$row->name.'" src="'.$piclink.'">';
                                                    $pic2 .= $piclink.'<br>';
                                                }
                                                echo '
                                                <div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
                                                    <div class="mt-card-item">
                                                        <div class="mt-card-avatar mt-overlay-1">
                                                            <div class="video-time">
                                                              <span style="float:left;" id="size">'.formatsize($row->size).'</span>
                                                              <span style="float:right;" id="time">'.formattime($row->duration,1).'</span>
                                                            </div>
                                                            <img class="lazy" src="'.m3u8_link($row->vid,$row->addtime,'pic',1,$server).'" alt="'.$row->name.'" style="height: 206px;width: 360px;">
                                                            <div class="mt-overlay">
                                                                <ul class="mt-info">
                                                                    <li>
                                                                        <a class="btn default btn-outline" href="'.links('play','index',$row->vid).'" target="_blank"><i class="fa fa-play"></i></a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                        <div class="mt-card-content">
                                                            <h3 class="mt-card-name oneline">'.$row->name.'</h3> 
                                                            <div class="mt-card-social">
                                                                <ul>
                                                                    <li>
                                                                        <a id="copyid'.$row->id.'" style="width:0px;height:0px;font-size:0px">'.$row->vid.'</a> 
                                                                        <!--a href="javascript:;" data-clipboard-action="copy" data-clipboard-target="#copyid'.$row->id.'" class="mt-clipboard"><i class="fa fa-copy"></i> Copy video ID</a-->
                                                                        <a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard"><i class="fa fa-copy"></i> Get share address</a>
                                                                    </li>
                                                                    <li>
                                                                        <a href="#long'.$row->id.'" data-toggle="modal" ><i class="fa fa-picture-o"></i> Video screenshots</a>
                                                                    </li>
                                                                    <li>
                                                                        <a href="javascript:;">
                                                                            <i class="fa fa-clock-o"></i>'.get_time($row->addtime).'</a>
                                                                    </li>
                                                                </ul>
                                                                 <ul>
                                                                    <li>
                                                                        <a href="javascript:;"><i class="fa fa-clone"></i>'.getzd('user','name',$row->uid).'</a>
                                                                    </li>
                                                                    <li>
                                                                        <a href="javascript:;"> <i class="fa fa-sort"></i> '.$cname.'</a>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
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
                                                            </div>
                                                </div>';
												$arr[$k]['name'] = $row->name;
												$arr[$k]['link'] = 'http://'.Web_Url.links('play','index',$row->vid);
												$arr[$k]['m3u8link'] = m3u8_link($row->vid,$row->addtime,'m3u8',$i,$server);
											}
                                            ?>
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
            <div style="padding-top:20px;">
                <div class="alert alert-danger">
                    <strong>Warning：</strong>Please confirm that the file resources you share comply with relevant local laws and regulations, and know the responsibilities and risks you need to bear!
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
}
$(document).ready(function() {
    var layer = layui.layer;
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
    })
});
$('#vall').addClass('open');
$("#vodlist").css('display','block');
$('#vlist_<?=$cid?>').addClass('active');
</script>