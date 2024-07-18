<!DOCTYPE html>
<div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                            <div class="row" >
                            <div class="col-md-12">
                                <!-- BEGIN VALIDATION STATES-->
                                <div class="portlet light portlet-fit portlet-form bordered">
                                    <div class="portlet-title">
                                        <div class="caption">
										<a href="<?=links('vod')?>"><span><i class="fa fa-arrow-left font-blue"></i> <strong>Back</strong></span></a>
										<br>
										<br>
                                            <span class="caption-subject font-red sbold uppercase"><i class="fa fa-upload fa-lg font-red"></i> Edit video &nbsp;</span>
                                        </div>
                                        <!--div class="actions">
                                            
                                  <div class="btn-group">
                                            <a class="btn red btn-outline  btn-sm" href="javascript:;" data-toggle="dropdown" data-hover="dropdown" data-close-others="true" aria-expanded="false"> Shortcuts
                                                <i class="fa fa-angle-down"></i>
                                            </a>
                                            <ul class="dropdown-menu pull-right">
                                                <li>
                                                    <a href="javascript:;" class="mt-clipboard" data-clipboard-action="copy" data-clipboard-target="#title">Copy video name</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:;" class="mt-clipboard" data-clipboard-action="copy" data-clipboard-target="#panvideoid">Copy video ID</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:;" class="mt-clipboard" data-clipboard-action="copy" data-clipboard-target="#panshare">Copy share address</a>
                                                </li>
                                                <li>
                                                    <a href="javascript:;" class="mt-clipboard" data-clipboard-action="copy" data-clipboard-target="#pantitlepic">Copy preview URL</a>
                                                </li>
                                            </ul>
                                        </div>
                                                                    
                                                                    
                                        </div-->
                                    </div>
                                    <div class="portlet-body">
                                        <!-- BEGIN FORM-->
                                        <form action="<?=links('vod','save',$vod->id)?>" class="layui-form form-horizontal" method="post">
                                            <div class="form-body" style="padding-bottom: 0;">
                                                <div id="divFileProgressContainer"></div>
                                            </div>
 
                                            <div class="form-body">
 
                                <div class="form-group margin-bottom-30 margin-top-30">
                                                <div class="form-group">
                                         
                                                    <label class="control-label col-md-3">Video name
                                                        <span class="required"> * </span>
                                                    </label>
                                                    <div class="col-md-6">
                                                        <input class="form-control" name="name" required  placeholder="Please fill in the video name...(default is upload file name)" lay-verify="required" type="text" id="title" value="<?=$vod->name?>"/> 
                                                        </div>
                                                </div>
										<style type="text/css">.layui-form-radio{padding-right: 0px;}</style>
                                       <div class="form-group">
                                          <label class="control-label col-md-3">Video classification
                                                        <span class="required" aria-required="true"> * </span>
                                                    </label>
                                                    <div class="col-md-6">
                                                        <div class="md-radio-inline">
                                                        <?php
                                                        foreach($class as $row){
                                                            $check = $row->id == $vod->cid ? ' checked=""' : '';
                                                            echo '<div class="md-radio">
                                                                <input type="radio" id="'.$row->id.'" name="cid" class="md-radiobtn" title="'.$row->name.'" value="'.$row->id.'"'.$check.'>
                                                                <!--label for="'.$row->id.'">
                                                                    <span></span>
                                                                    <span class="check"></span>
                                                                    <span class="box"></span> '.$row->name.' </label-->
                                                            </div>';
                                                        }
                                                        ?>  
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                  <label class="control-label col-md-3">Private classification
                                                        <span class="required" aria-required="true"></span>
                                                    </label>
                                                <div class="col-md-6">
                                                    
                                              <select name="mycid" class="form-control">
                                                    <option value="0">├&nbsp;please select a private category...</option>
                                                        <?php
                                                        foreach($myclass as $row){
                                                            $check = $row->id == $vod->mycid ? ' selected' : '';
                                                            $arr = $this->csdb->get_select('myclass','*',array('fid'=>$row->id),'id ASC',100);
                                                            echo '<option value="'.$row->id.'"'.$check.'>├&nbsp;'.$row->name.'</option>';
                                                            foreach($arr as $row2){
                                                                $che2 = $row2->id == $vod->mycid ? ' selected' : '';
                                                                echo '<option value="'.$row2->id.'"'.$che2.'>&nbsp;&nbsp;├&nbsp;'.$row2->name.'</option>';
                                                            }
                                                        }
                                                        ?>
                                                </select>
                                                </div>
                                            </div>
    <div class="form-group">
         <label class="control-label col-md-3">Video ID
         <span class="required"> * </span>
         </label>
         <div class="col-md-6">
           <input  readonly="readonly" class="form-control" name="panvideoid" id="panvideoid" required  lay-required="" placeholder="" value="<?=$vod->vid?>" type="" />
         </div>
    </div>
    <div class="form-group">
         <label class="control-label col-md-3">Thumbnail
         <span class="required"> * </span>
         </label>
         <div class="col-md-6">
            <?php if($vod->is_remote_m3u8): ?>
                <input  class="form-control" name="thumnail_url" id="thumnail_url" required  lay-required="" placeholder="" value="<?= $vod->thumnail_url ?>" type="" />
            <?php else: ?>
                <input  readonly="readonly" class="form-control" name="thumnail_url" id="thumnail_url" required  lay-required="" placeholder="" value="<?=m3u8_link($vod->vid,$vod->addtime,'pic',1,$server)?>" type="" />
            <?php endif; ?>
         </div>
    </div>
    <?php if($vod->is_remote_m3u8): ?>
        <div class="form-group">
            <label class="control-label col-md-3">M3u8 Url
            <span class="required"> * </span>
            </label>
            <div class="col-md-6">
                <input type="text"  class="form-control" name="m3u8_url" id="m3u8_url" required  lay-required="" placeholder="" value="<?= $vod->m3u8_url ?>"  />
            </div>
        </div>
    <?php endif; ?>
    <div class="form-group">
         <label class="control-label col-md-3">Play address
         <span class="required"> * </span>
         </label>
         <div class="col-md-6">
           <input readonly="readonly" class="form-control" name="panshare" id="panshare" required  lay-required="" placeholder="" value="https://<?=Web_Url.links('play','index',$vod->vid)?>" type="" />
         </div>
    </div>
    <div class="form-group">
         <label class="control-label col-md-3">Durations
         <span class="required"> * </span>
         </label>
         <div class="col-md-6">
           <input readonly="readonly" class="form-control" name="panvideotime" id="panvideotime" required   placeholder="" value="<?=formattime((int)$vod->duration,1)?>" type="" />
         </div>
    </div>
    <div class="form-group">
         <label class="control-label col-md-3">Video size
         <span class="required"> * </span>
         </label>
         <div class="col-md-6">
           <input  readonly="readonly" class="form-control" name="panvideosize" id="panvideosize" required   placeholder="" value="<?=formatsize($vod->size)?>" type="" />
         </div>
    </div>
                                            <div class="form-actions">
                                                <div class="row">
                                                    <div class="col-md-offset-3 col-md-9">
                                                        <button type="submit" lay-submit lay-filter="*" class="btn btn-lg green"><i class="fa fa-check"></i> Submit </button>
                                                        <button type="reset" class="btn btn-lg grey-salsa btn-outline" ><i class="fa fa-refresh"></i> Reset</button>
                                                    </div>
                                                </div>
                                            </div>
                                    </div>

                                        </form>
                                </div>
                            </div>
                        </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    $('#a3').addClass('active');
    </script>