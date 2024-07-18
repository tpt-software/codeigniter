<!DOCTYPE html>
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
                                                <div class="tab-pane active" id="overview_1">
                                                    <table class="table table-striped table-hover table-bordered reponse-table">
                                                        <thead>
                                                            <tr>
                                                                <th> Video name </th>
                                                                <th> Category </th>
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
                                                                <td>'.date('Y-m-d H:i:s',$row->addtime).'</td>
                                                                <td><a onclick="n='.$k.';get_mode(\'fetch\');" href="#longshare" data-toggle="modal" class="mt-clipboard btn btn-sm btn-default"><i class="icon-note"></i>Link</a><a href="#long'.$row->id.'" data-toggle="modal"  class="btn btn-sm btn-default"> <i class="fa fa-file-picture-o"></i>Screenshot</a><a  href="'.links('play','index',$row->vid).'"  target="_blank" class="btn btn-sm btn-default">  <i class="fa fa-search"></i>Preview</a><a  href="javascript:getajax(\''.links('ajax','fav',$row->id).'\',\'fav\');" class="btn btn-sm btn-default">  <i class="fa fa-heart"></i>Collection</a></td>
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