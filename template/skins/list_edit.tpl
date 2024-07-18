<!DOCTYPE html>
<div class="page-content-wrapper">
                <div class="page-content">
                            <div class="row" >
                            <div class="col-md-12">
                                <div class="portlet light portlet-fit portlet-form bordered">
                                    <div class="portlet-title">
                                        <div class="caption">
                                            <i class="fa fa-plus fa-lg font-blue"></i>
                                            <span class="caption-subject font-blue sbold uppercase">Add category &nbsp;</span>
                                            <span class="caption-helper"> （You have a total of  <?=$this->csdb->get_nums('myclass',array('uid'=>$user->id))?>  categories） </span>
                                        </div>
 
                                    </div>
                                    <div class="portlet-body">
                                        <!-- BEGIN FORM-->
                                        <form  action="<?=links('lists','save',$id)?>" class="layui-form form-horizontal" method="post" >
                                            <div class="form-body">
 
  
                               
                                 <div class="form-group">
                                                  <label class="control-label col-md-3">Sub-headings
                                                        <span class="required" aria-required="true">   </span>
                                                    </label>
                                                <div class="col-md-6">
                                              <select name="fid" class="form-control">
                                                    <option value="0">Default first class</option>
                                                        <?php
                                                        foreach($myclass as $row){
                                                            $check = $row->id == $fid ? ' selected' : '';
                                                            echo '<option value="'.$row->id.'"'.$check.'>'.$row->name.'</option>';
                                                        }
                                                        ?>
                                                </select>
                                                </div>
                                            </div>
                                            
                                
                      
                                                <div class="form-group">
                                         
                                                    <label class="control-label col-md-3">Category Name
                                                        <span class="required"> * </span>
                                                    </label>
                                                    <div class="col-md-6">
                                                          <input type="text" name="name" required  lay-verify="required" placeholder="Please enter a category name" value="<?=$name?>"   class="form-control"/> 
                                                        </div>
                                                </div>
                                            <div class="form-actions">
                                                <div class="row">
                                                    <div class="col-md-offset-3 col-md-9">
                                                        <button type="submit" lay-submit lay-filter="*"  class="btn btn-lg green"><i class="fa fa-check"></i> Submit </button>
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
    <script type="text/javascript">
    $('#a2').addClass('active');
    </script>