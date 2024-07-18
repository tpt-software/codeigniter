<!DOCTYPE html>
<head>
<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="<?=Web_Path?>packs/layer/theme/default/layer.css">
<link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/modules/layer/default/layer.css">
<link rel="stylesheet" href="<?=Web_Path?>packs/static/css/mod.css">
<link rel="stylesheet" type="text/css" href="/packs/plupload/css/webuploader.css">
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests" />
<!-- Google tag new (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-7V5WS9M2D0"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-7V5WS9M2D0');
</script>
 </head>
<div class="page-content-wrapper">
    <div class="page-content">
        <div class="row" >
            <div class="col-md-12">
			<div class="portlet light bordered">
			<center><div style="font-size: 12px; color:red; font-weight: bold; text-transform: uppercase;">Warning: Update new backup domain <a href="https://14412882.net" target="_blank">14412882.net</a>, please replace the new domain in your database, Thank you!</span></div></center></div>
                <div class="portlet light portlet-fit portlet-form bordered">
                    <div class="portlet-title">
                        <div class="caption">
                            <i class="fa fa-play fa-spin" style="color: red;"></i>
                            <span class="caption-subject font-red sbold uppercase">Upload video &nbsp;</span>
                        </div>
                    </div>
                    <div class="portlet-body">
					
                        <div class="form-horizontal custom-form-horizontal">
							<div class="form-body custom-form-body">

                 				<div class="form-group">
                                    <label class="control-label col-md-3">Upload server
                                    	<span class="required" aria-required="true"> * </span>
                                    </label>
                                	<div class="col-md-6">
                              			<select id="fid" name="fid" class="bs-select form-control" title="please choose the server...">
	                                        <?php
											if($fid > 0) echo '<option value="0">please choose the server...</option>';
	                                        foreach($server as $row){
	                                            $check = $row->id == $fid ? ' selected' : '';
                                                echo '<option value="'.$row->id.'"'.$check.'>'.$row->name.'</option>';
	                                        }
	                                        ?>
                                		</select>
                                	</div>
                            	</div>
                            	<div class="form-group">
                                  	<label class="control-label col-md-3">Video classification
                                        <span class="required" aria-required="true"> * </span>
                                    </label>
                                    <div class="col-md-6">
                                        <div class="md-radio-inline">
									<?php
                                        foreach($class as $row){
                                        $check = $row->id == $cid ? ' checked=""' : '';
                                        echo '
                                            <div class="md-radio">
                                                <input type="radio" id="'.$row->id.'" name="cid" class="md-radiobtn" value="'.$row->id.'"'.$check.'>
                                                <label for="'.$row->id.'">
                                                    <span></span>
                                                    <span class="check"></span>
                                                    <span class="box"></span> '.$row->name.'
                                                </label>
                                            </div>';
                                        }
                                    ?>
                                        </div>
                                    </div>
                                </div>
                 				<div class="form-group">
                                    <label class="control-label col-md-3">Private classification <i>(optional)</i>
                                    	<span class="required" aria-required="true"></span>
                                    </label>
                                	<div class="col-md-6">
                              			<select id="mycid" name="mycid" class="bs-select form-control" title="please select a private category...">
	                                        <?php
	                                        foreach($myclass as $row){
	                                            $check = $row->id == $mycid ? ' selected' : '';
                                                $arr = $this->csdb->get_select('myclass','*',array('fid'=>$row->id),'id ASC',100);
                                                echo '<option value="'.$row->id.'"'.$check.'>├&nbsp;'.$row->name.'</option>';
                                                foreach($arr as $row2){
                                                    $che2 = $row2->id == $mycid ? ' selected' : '';
                                                    echo '<option value="'.$row2->id.'"'.$che2.'>&nbsp;&nbsp;&nbsp;&nbsp;├&nbsp;'.$row2->name.'</option>';
                                                }
	                                        }
	                                        ?>
                                		</select>
                                	</div>
                            	</div>
								<center><span>Currently we are supporting the <b><font color=red>mp4|ts|mkv|mov|avi</font></b> videos upload. If you get an error, please <b><font color=red>convert to MP4</font>, We suggest you use the software <a href="https://videoconverter.wondershare.com" target="_blank">videoconverter.wondershare.com</a> to convert and maintain the same video quality. Thank you for using the service!</b></span></center>
								<br>
								<p class="btn btn-sm btn-default" style="background: #d70466; color: #fff;" onclick="handleRetryAll()"><i class="fa fa-refresh"></i> Retry all</p> 
								<p class="btn btn-sm btn-default" style="background: #25b09b; color: #fff;" onclick="handleClearCompleted()"><i class="fa fa-times"></i> Clear completed</p> 
								<div class="form-group" style="max-width: 1200px;margin: 0 auto;">
									<div id="upload_box">
										<div id="uploader" class="wu-example">
										    <!--Used to store file information-->
										    <div class="btns">
										        <div id="picker">Select</div>
										        <div id="ctlBtn">Upload</div>
										    </div>
										    <div id="thelist"></div>
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
<script type="text/javascript" src="/packs/plupload/js/webuploader.js"></script>
<script type="text/javascript">
var uplink = '<?=links('upload')?>';
var cid = <?=$cid?>,mycid = <?=$mycid?>,fid = <?=$fid?>,kstime = 0;
$(document).ready(function() {
	$('#a1').addClass('active');
	$('.md-radio').click(function() {
		cid = $(this).children('input').val();
		
	});
	$("#mycid").change(function(){
		mycid = $(this).val();
		
	});
	$("#fid").change(function(){
		fid = $(this).val();

	});
	$('#picker').click(function() {
		if(cid == 0){
			layer.msg('Please select a video category first',{icon:2});
			return false;
		}
		if(fid == 0){
			layer.msg('Please select an upload server first',{icon:2});
			return false;
		}
	});
});
var zmurl = (("https:" == document.location.protocol) ? " https://" : " https://")+'<?=Web_Zm_Url.Web_Path?>index.php/ting';
var upmsg = 0;
var uploader = WebUploader.create({
	swf: '/packs/plupload/js/Uploader.swf', 
	server: '<?=$saveurl?>?key=<?=$key?>',
	pick: '#picker',
	chunked: true,    
	prepareNextFile: true,
	chunkSize : 90*1024*1024,
	chunkRetry: 3,
	threads: 2,
	fileVal: 'video',
	accept: {
		title: 'Video file upload',
		extensions: '<?php echo implode(',',array_filter(explode('|', Up_Ext)));?>',
	},
	fileNumLimit: 9000000,
	fileSizeLimit: 90000000 * 1024 * 1024,
	fileSingleSizeLimit: 90000000 * 1024 * 1024
});
uploader.on('fileQueued', function (file) {

    var fileSize = file.size;

    var formattedSize = formatSize(fileSize);

    $('#thelist').append('<div id="' + file.id + '" class="item">' +
    '<h5 class="info">' +
    '<div style="display: inline-block; font-weight: bold;">' + '<i class="fa fa-file-video-o" aria-hidden="true" style="font-size: 24px; margin-right: 8px;"></i>' + file.name + ' ' +
    '<span class="label label-info">' + formattedSize + '</span></div>' +
    '<span title="Delete" onclick="del(\'' + file.id + '\')"><button class="rounded-button" type="button"><i class="fa fa-times" aria-hidden="true"></i></button></span>' +
    '<span id="retry-button-' + file.id + '" class="retry-button" title="Retry" onclick="retry(\'' + file.id + '\')"><a class="fa fa-refresh"></a></span>' +
    '</h5>' +
    '<p class="state" style="color: #f90; font-size: 13px;  font-style: italic;">Waiting for upload...</p>' +
    '</div>');
    $('#thelist').addClass('bord');
});

$('#ctlBtn').click(function(event) {
	if(cid == 0){
		layer.msg('No video category selected, unable to upload~',{icon:2});
		return false;
	} 
	if(fid == 0){
		layer.msg('No Server selected, unable to upload~',{icon:2});
		return false;
	}
	let sKey = '';
	$.ajax({
		type: "POST",
		url: '/upload/getkey',
		data: {
			cid: cid,
			mycid: mycid,
			fid: fid
		},
		dataType: "json",
		success: function(data) {
			if (data.status == 'success') {
				sKey = data.data;
				let servers = <?= json_encode($server); ?>;
				let uploadUrl = '';
				servers.forEach(function(item){
					if (item.id == fid) {
						uploadUrl = item.apiurl + 'upload.php?key=' + sKey;
					}
				})
				uploader.options.server = uploadUrl;
				uploader.upload(); 
			} else {
				layer.msg('Can not get key~',{icon:2});
				return false;
			}
		},
		error: function (data) {
			layer.msg('Can not get key~',{icon:2});
			return false;
		}
    });
	
	kstime = new Date().getTime();
	uploader.on('uploadProgress', function(file, percentage) {
		var $li = $('#' + file.id),
			$percent = $li.find('.progress .progress-bar');

		if (!$percent.length) {
			$percent = $('<div class="progress progress-striped active">' +
				'<div class="process-container">' +
				'<div class="progress-bar" role="progressbar">' +
				'</div>' +
				'</div>' + '</div>').appendTo($li).find('.progress-bar');
		}

		var xztime = new Date().getTime();
		var jstime = xztime - kstime;
		var sd = file.size * percentage / jstime * 1000 / 1024 / 1024;
		if (sd < 1) {
			sd = (sd * 1024).toFixed(2) + 'kb';
		} else {
			sd = sd.toFixed(2) + 'Mb';
		}

		var waitMessage = 'Uploading... <i class="fa fa-spinner" aria-hidden="true"></i>';
			$li.find('p.state').html('<span style="color: blue; font-size: 13px;  font-style: italic;">' + waitMessage + '<span style="color: red"> ('+ (percentage * 100).toFixed(0) + '%)</span>');
			$percent.css( 'width', percentage * 100 + '%' );
	});

	uploader.on( 'uploadSuccess', function( file,json ) {
		if(json.code == 1){
		var successMessage = 'Uploaded successfully, has been added to the transcoding queue <i class="fa fa-check" aria-hidden="true"></i>';
			$('#' + file.id).find('p.state').html('<span data-file-id="'+file.id+'" class="clear-completed" style="color: #080; font-size: 13px;  font-style: italic;">' + successMessage + '</span>');
			$.get(zmurl+'?id='+json.did);
		}else{
			$( '#'+file.id ).find('p.state').html('<span data-file-id="'+file.id+'" class="clear-completed" style="color: red; font-size: 13px;  font-style: italic;">Upload video successfully, please wait for video transcoding: '+json.msg+'</span>');
		}
	});
	uploader.on('uploadError', function (file) {
		var $fileItem = $('#' + file.id);
		var $retryButton = $fileItem.find('#retry-button-' + file.id);

		if (!$retryButton.length) { 

			$fileItem.find('.state').append('<span id="retry-button-' + file.id + '" class="retry-button" title="Retry" onclick="retry(\'' + file.id + '\')"><a class="fa fa-refresh"></a></span>');
			$retryButton = $fileItem.find('#retry-button-' + file.id); 
		}

		$retryButton.show();
		var errorMessage =  'Upload error <i class="fa fa-times" aria-hidden="true"></i>';
		$fileItem.find('p.state').html('<span data-file-id="' + file.id + '" class="retry-error" style="color: red; font-style: italic;">' + errorMessage + '</span>');
	});
		uploader.on('uploadComplete', function (file) {
		var $fileItem = $('#' + file.id);
		var $retryButton = $fileItem.find('#retry-button-' + file.id);
	});
	});
function del(_id){
	$('#'+_id).remove();
	uploader.removeFile(_id);
}
</script>

<script type="text/javascript">
var uploading = false;

window.addEventListener('beforeunload', function (event) {
    if (uploading) {

        var confirmationMessage = 'You have an upload in progress. If you leave the page, the upload will be cancelled. Are you sure you want to leave?';

        var userConfirmation = confirm(confirmationMessage);
        if (!userConfirmation) {
            event.returnValue = confirmationMessage;
            return confirmationMessage;
        } else {
            uploading = false;
        }
    }
});

uploader.on('uploadStart', function (file) {
    uploading = true;
});

uploader.on('uploadComplete', function (file) {
    uploading = false;
});

</script>

<script type="text/javascript">
function retry(fileId) {
    var file = uploader.getFile(fileId);
    if (file) {
        uploader.retry(file);
    }
}
</script>

<div class="fa fa-refresh" aria-hidden="true" onclick="reloadUpload()">Reload</div>


<script type="text/javascript">
function formatSize(size) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    let i = 0;
    while (size >= 1024 && i < 4) {
        size /= 1024;
        i++;
    }
    return size.toFixed(2) + ' ' + units[i];
}
</script>

<script>
	function handleRetryAll() { 
		const retryErrorSpans = $('span.retry-error'); 
		retryErrorSpans.each(function() {
			const fileId = $(this).attr('data-file-id'); 

			if (fileId) {
				retry(fileId)
			} 
		});  
	}	
	function handleClearCompleted() { 
		const retryErrorSpans = $('span.clear-completed'); 

		retryErrorSpans.each(function() {
			const fileId = $(this).attr('data-file-id'); 
			if (fileId) {
				del(fileId)
			}
		});  
	}	
</script>