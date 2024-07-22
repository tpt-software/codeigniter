<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>System Configuration</title>
	    <link rel="stylesheet" href="/packs/layui/css/layui.css">
		<link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
		<link rel="stylesheet" type="text/css" href="/packs/font/font.css">
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<script src="/packs/jquery/jquery.min.js"></script>
		<script src="/packs/layui/layui.js"></script>
	</head>
	<body>
		<?= $header ?>
		<?= $leftsidebar ?>
		<div class="main">
			<form class="layui-form layui-form-pane setting_form" method="post" action="<?=site_url('setting/save')?>">
				<div class="layui-tab layui-tab-brief" lay-filter="setting">
					<ul class="layui-tab-title">
						<li class="layui-this" lay-id="set1">Website settings</li>
						<li class="" lay-id="set2">Slice settings</li>
						<li class="" lay-id="set3">Screenshot settings</li>
						<li class="" lay-id="set4">Watermark settings</li>
						<li class="" lay-id="set5">Upload settings</li>
						<li class="" lay-id="set6">Sync settings</li>
						<li class="" lay-id="set7">Other settings</li>
					</ul>
					<div class="layui-tab-content">
						<!-- Basic website settings -->
						<div class="layui-tab-item layui-show">
							<div class="layui-form-item">
								<label class="layui-form-label">Website name</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_Name" required  lay-verify="required" placeholder="Please enter a site name" autocomplete="off" class="layui-input" value="<?=Web_Name?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Such as: 88 disks</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Domain name</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_Url" required  lay-verify="required" placeholder="Please enter the domain name of the site" autocomplete="off" class="layui-input" value="<?=Web_Url?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Site domain name without https://</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Sliced ​​domain name</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_Zm_Url" required  lay-verify="required" placeholder="Please enter a domain name for slicing" autocomplete="off" class="layui-input" value="<?=Web_Zm_Url?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The domain name used for slicing, bound to the domain name of the website, without https://</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">M3u8 domain name</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_M3u8_Url" placeholder="The domain name of the M3u8 address" autocomplete="off" class="layui-input" value="<?=Web_M3u8_Url?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The domain name of the M3u8 address, the domain name is bound to:<?=Zm_Dir?></div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Image domain name</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_Pic_Url" placeholder="The domain name of the screenshot image address" autocomplete="off" class="layui-input" value="<?=Web_Pic_Url?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The domain name of the image address, the domain name is bound to:<?=Zm_Dir?></div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Website path</label>
								<div class="layui-input-inline">
									<input type="text" name="Web_Path" required  lay-verify="required" placeholder="Please enter the site path" autocomplete="off" class="layui-input" value="/">
								</div>
								<div class="layui-form-mid layui-word-aux">Site path, root directory such as: / Secondary directory such as: /m3u8/</div>
							</div>
						</div>
						<!-- Video slice settings -->
						<div class="layui-tab-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Slice save directory</label>
								<div class="layui-input-inline">
									<input type="text" name="Zm_Dir" placeholder="Slice save directory" autocomplete="off" class="layui-input" value="<?=Zm_Dir?>">
								</div>
								<div class="layui-form-mid layui-word-aux">For example: D:/m3u8/, the website directory can start with ./</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Slice method</label>
								<div class="layui-input-inline">
									<select name="Zm_Preset">
										<option value="ultrafast" <?=Zm_Preset=='ultrafast'?'selected':''?> >Ultra Fast</option>
										<option value="veryfast" <?=Zm_Preset=='veryfast'?'selected':''?> >Very Fast</option>
										<option value="fast" <?=Zm_Preset=='fast'?'selected':''?> >Fast</option>
										<option value="medium" <?=Zm_Preset=='medium'?'selected':''?> >Medium (Quality first)</option>
									</select>
								</div>
								<div class="layui-form-mid layui-word-aux">Medium (Quality first), slice speed is slower</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Slice rate</label>
								<div class="layui-input-inline">
									<input type="text" name="Zm_Kbps" placeholder="Please enter the size after slicing" autocomplete="off" class="layui-input" value="<?=Zm_Kbps?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The code rate after slicing, the bigger the clearer</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Slice size</label>
								<div class="layui-input-inline">
									<input type="text" name="Zm_Size" placeholder="Please enter the size after slicing" autocomplete="off" class="layui-input" value="<?=Zm_Size?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Used to constrain the sliced ​​video size，such as 320x180，Leave blank for original painting</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">TS duration</label>
								<div class="layui-input-inline">
									<input type="text" name="Zm_Time" placeholder="The duration of a single TS" autocomplete="off" class="layui-input" value="<?=Zm_Time?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The duration of a single TS，It is recommended to set it to around 10</div>
							</div>
						</div>
						<!-- Screenshot settings -->
						<div class="layui-tab-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Screenshot switch</label>
								<div class="layui-input-inline">
									<input type="radio" name="Jpg_On" value="0" title="Turn off" <?=Jpg_On==0?'checked':''?>>
									<input type="radio" name="Jpg_On" value="1" title="Turn on" <?=Jpg_On==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Video generation jpg switch settings</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Number of screenshots</label>
								<div class="layui-input-inline">
									<input type="text" name="Jpg_Num" placeholder="" autocomplete="off" class="layui-input" value="<?=Jpg_Num?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The total number of intercepted pictures, the default is 1</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Intervals</label>
								<div class="layui-input-inline">
									<input type="text" name="Jpg_Time" placeholder="" autocomplete="off" class="layui-input" value="<?=Jpg_Time?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Screenshot interval, seconds, how many seconds to take a screenshot</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Screenshot size</label>
								<div class="layui-input-inline">
									<input type="text" name="Jpg_Size" placeholder="The size of the screenshot" autocomplete="off" class="layui-input" value="<?=Jpg_Size?>">
								</div>
								<div class="layui-form-mid layui-word-aux">The width and height of the captured image，such as 320x180，Leave blank to match the video</div>
							</div>
						</div>
						<!-- Watermark subtitle settings -->
						<div class="layui-tab-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Watermark position</label>
								<div class="layui-input-inline">
									<select name="Zm_Sy">
										<option value="0" <?=Zm_Sy==0?'selected':''?>>Turn off</option>
										<option value="1" <?=Zm_Sy==1?'selected':''?>>Upper left</option>
										<option value="2" <?=Zm_Sy==2?'selected':''?>>Upper right</option>
										<option value="3" <?=Zm_Sy==3?'selected':''?>>Bottom left</option>
										<option value="4" <?=Zm_Sy==4?'selected':''?>>Bottom right</option>
									</select>
								</div>
								<div class="layui-form-mid layui-word-aux">Video slice watermark position</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Watermark spacing</label>
								<div class="layui-input-inline">
									<input type="text" name="Zm_Sylt" placeholder="" autocomplete="off" class="layui-input" value="<?=Zm_Sylt?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Watermark spacing，Such as: 10:10</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Subtitle switch</label>
								<div class="layui-input-inline">
									<input type="radio" name="Zm_Zm" value="0" title="Turn off" <?=Zm_Zm==0?'checked':''?>>
									<input type="radio" name="Zm_Zm" value="1" title="Turn on" <?=Zm_Zm==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Video subtitle switch</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Subtitle content</label>
								<div class="layui-input-inline" style="width: 500px;">
									<textarea type="text" name="Zm_Zmtxt" placeholder="Subtitle content" class="layui-textarea"><?=$zimu?></textarea>
								</div>
								<div class="layui-form-mid layui-word-aux">Subtitle content</div>
							</div>
						</div>
						<!-- Upload settings -->
						<div class="layui-tab-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Upload path</label>
								<div class="layui-input-inline">
									<input type="text" name="Up_Dir" placeholder="Please enter the path where the video is uploaded and saved" autocomplete="off" class="layui-input" value="<?=Up_Dir?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Video upload storage path，Such as: F:/video/，Website directory please start with ./</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Supported format</label>
								<div class="layui-input-inline">
									<input type="text" name="Up_Ext" placeholder="Please enter a supported upload format" autocomplete="off" class="layui-input" value="<?=Up_Ext?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Upload supported formats, such as: mp4|mkv|flv</div>
							</div>
						</div>
						<!-- Sync settings -->
						<div class="layui-tab-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Sync switch</label>
								<div class="layui-input-inline">
									<input type="radio" name="Tb_Zt" value="0" title="Turn off" <?=Tb_Zt==0?'checked':''?>>
									<input type="radio" name="Tb_Zt" value="1" title="Turn on" <?=Tb_Zt==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Transcoding synchronization switch</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Sync address</label>
								<div class="layui-input-inline">
									<input type="text" name="Tb_Url" placeholder="Please enter the synchronization address" autocomplete="off" class="layui-input" value="<?=Tb_Url?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Such as: https://www.xxx.com/api.php</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Sync key</label>
								<div class="layui-input-inline">
									<input type="text" name="Tb_Key" placeholder="Please enter the sync key" autocomplete="off" class="layui-input" value="<?=Tb_Key?>">
								</div>
								<div class="layui-form-mid layui-word-aux">Please enter the sync key</div>
							</div>
						</div>
						<!-- Other settings -->
						<div class="layui-tab-item layui-show">
							<div class="layui-form-item">
								<label class="layui-form-label">m3u8 reserved</label>
								<div class="layui-input-inline">
									<input type="radio" name="Del_M3u8" value="0" title="Reserve" <?=Del_M3u8==0?'checked':''?>>
									<input type="radio" name="Del_M3u8" value="1" title="Not reserved" <?=Del_M3u8==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Whether to keep the sliced ​​M3U8 file after deleting the video</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Source file retention</label>
								<div class="layui-input-inline">
									<input type="radio" name="Del_Mp4" value="0" title="Reserve" <?=Del_Mp4==0?'checked':''?>>
									<input type="radio" name="Del_Mp4" value="1" title="Not reserved" <?=Del_Mp4==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Whether to keep the uploaded source file after slicing</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Sign Up</label>
								<div class="layui-input-inline">
									<input type="radio" name="Web_Reg" value="0" title="Pass" <?=Web_Reg==0?'checked':''?>>
									<input type="radio" name="Web_Reg" value="1" title="Pending" <?=Web_Reg==1?'checked':''?>>
								</div>
								<div class="layui-form-mid layui-word-aux">Whether the default member registration needs to be reviewed</div>
							</div>
							<div class="layui-form-item">
							<div class="layui-form-item">
							<div class="layui-form-item">
								<label class="layui-form-label">Website Announcement</label>
								<div class="layui-input-inline" style="width: 450px;">
									<textarea type="text" name="Web_Gg" placeholder="Website Announcement" class="layui-textarea"><?=Web_Gg?></textarea>
								</div>
								<div class="layui-form-mid layui-word-aux">Website Announcement</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Statistical code</label>
								<div class="layui-input-inline" style="width: 450px;">
									<textarea type="text" name="Admin_Count" placeholder="Statistical code" class="layui-textarea"><?=Admin_Count?></textarea>
								</div>
								<div class="layui-form-mid layui-word-aux">Please enter the statistical code</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Require OTP when login</label>
								<div class="layui-input-inline">
									<input type="radio" name="is_otp_admin" value="1" title="On" <?=Is_OTP==1?'checked':''?>>
									<input type="radio" name="is_otp_admin" value="0" title="Off" <?=Is_OTP==0?'checked':''?>>
								</div>
							</div>
						</div>
						<div class="layui-form-item">
							<div class="layui-input-block" style="padding-top: 10px">
								<button class="layui-btn layui-btn2" lay-filter="setting" lay-submit>Submit</button>
								<button type="reset" class="layui-btn layui-btn-primary">Reset</button>
							</div>
						</div>
					</div>
				</div>    
			</form>
		</div>
		
		<script src="/packs/admin/js/common.js"></script>
		<script type="text/javascript">
			layui.use(['form','element'], function(){
				var form = layui.form;
				var element = layui.element;
				element.tabChange('setting', 'set1');
			});
		</script>
	</body>
</html>