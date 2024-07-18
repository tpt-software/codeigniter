<!DOCTYPE html>
		<link href="/packs/assets/jstree/themes/default/style.min.css" rel="stylesheet" type="text/css" />
	<style>
		.table th, .table td { 
			text-align: center;
			vertical-align: middle!important;
		}
		.modify-btn {
			background-color: #00a67d!important;
			color: #fff;
		}

		.delete-btn {
			background-color: #f52257!important;
			color: #fff;
		}
	</style>
<div class="page-content-wrapper">
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE HEAD-->
                    <!-- END PAGE HEAD-->
                    <!-- BEGIN PAGE BREADCRUMB -->              
                    <!-- END PAGE BREADCRUMB -->
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
					<div class="col-md-12">
						<div class="portlet light bordered">
						<center><span style="font-size: 12px; color:red; font-weight: bold; text-transform: uppercase;"> Warning: Update new backup domain <a href="https://14412882.net" target="_blank">14412882.net</a>, please replace the new domain in your database, Thank you!</span></center>
                                    </div></div>
                    	                 <div class="col-md-6">
 	  <div class="portlet light bordered">
 	  	         <div class="portlet-title">
                                    <div class="caption">
                                    <i class="fa fa-clone fa-lg font-red"></i>
                                        <span class="caption-subject font-red bold uppercase">My category</span>
                                        <span class="caption-helper"> （You have a total of  <?=$this->csdb->get_nums('myclass',array('uid'=>$user->id))?>  categories） </span>
                                    </div>
	                               <div class="actions">
	                                  	<div class="btn-group">
	                                        <a class="btn blue btn-outline  btn-sm" href="<?=links('lists','edit')?>" > <i class="fa fa-plus"></i> Add category </a>
	                                    </div>                     
	                                </div>
                                </div>
 	      						<div class="portlet-body">
                                        <div class="tab-content">
                                            <div class="tab-pane active" id="overview_1">
                                                    <table class="table table-striped table-hover table-bordered">
                                                        <thead>
                                                            <tr>
                                                                <th> Category ID </th>
                                                                <th> Category Name </th>
                                                                <th> Action </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
											<?php
												if(empty($myclass)) echo '<tr><td align="center" height="50" colspan="3">No related records</td></tr>';
												foreach($myclass as $row){
													echo '<tr><td>'.$row->id.'</td><td style="text-align: left;"><a href="'.links('lists','vod',$row->id).'">├&nbsp;'.$row->name.'</a></td><td><a href="'.links('lists','edit',$row->id).'" class="btn btn-sm btn-default modify-btn"><i class="fa fa-edit"></i> Modify </a><a href="javascript:getajax(\''.links('lists','del',$row->id).'\',\'del\');"  class="btn btn-sm btn-default delete-btn">  <i class="fa fa-remove"></i> Delete </a></td></tr>';
													$arr = $this->csdb->get_select('myclass','*',array('fid'=>$row->id),'id ASC',100);
												foreach($arr as $row2){
													echo '<tr><td>'.$row2->id.'</td><td style="text-align: left;"><a href="'.links('lists','vod',$row2->id).'">&nbsp;&nbsp;&nbsp;&nbsp;├&nbsp;'.$row2->name.'</a></td><td><a href="'.links('lists','edit',$row2->id).'" class="btn btn-sm btn-default"><i class="fa fa-edit"></i> Modify </a><a href="javascript:getajax(\''.links('lists','del',$row2->id).'\',\'del\');"  class="btn btn-sm btn-default delete-btn">  <i class="fa fa-remove"></i> Delete </a></td></tr>';
													}
												}
											?>

                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>  
                                    </div>
                        </div>
 
                    	
                        <div class="col-md-6">
                            <div class="portlet light bordered">
                                <div class="portlet-title">
                                    <div class="caption">
                                    <i class="fa fa-search fa-lg font-blue"></i>
                                        <span class="caption-subject font-blue-sharp bold uppercase">Category preview</span>
                                     </div>
                                </div>
                                
                                <div class="portlet-body">
                                    <div id="tree_1" class="tree-demo">
                                    <ul>
                                        <li data-jstree='{ "opened" : true }'>My category
                                           	<?php
											foreach($myclass as $row){
												echo '<ul id="row_'.$row->id.'" ><li data-jstree=\'{ "opened" : true }\' ><a href="'.links('lists','vod',$row->id).'">'.$row->name.'</a><ul>';
												$arr = $this->csdb->get_select('myclass','*',array('fid'=>$row->id),'id ASC',100);
												foreach($arr as $row2){
													echo '<li data-jstree=\'{ "type" : "file"}\' > <a href="'.links('lists','vod',$row2->id).'">'.$row2->name.'</a></li>';
												}
												echo '</ul></li></ul>';
											}
											?>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
        </div>
        <script src="/packs/assets/jstree/jstree.min.js" type="text/javascript"></script>
        <script src="/packs/assets/js/app.min.js" type="text/javascript"></script>
        <script src="/packs/assets/js/ui-tree.min.js" type="text/javascript"></script>
		<script type="text/javascript">
		$('#a4').addClass('active');
		</script>