<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">
    <!--<![endif]-->
    <!-- BEGIN HEAD -->
<head>
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <meta charset=utf-8>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta content="width=device-width, initial-scale=1" name="viewport" />
     <title><?=$title?></title>
		<link rel="stylesheet" href="<?=Web_Path?>packs/static/css/mod.css">
		<link rel='stylesheet' href='/packs/layui/css/layui.css'>
		<script type='text/javascript' src='/packs/layui/layui.js'></script>
		<script type='text/javascript' src='/packs/jquery/jquery.min.js'></script>
        <!-- BEGIN GLOBAL MANDATORY STYLES -->
        <link href="/packs/assets/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/simple-line-icons/simple-line-icons.min.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/bootstrap-switch/css/bootstrap-switch.min.css" rel="stylesheet" type="text/css" />
        <!-- END GLOBAL MANDATORY STYLES -->
        <!-- BEGIN PAGE LEVEL PLUGINS -->
        <link href="/packs/assets/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/morris/morris.css" rel="stylesheet" type="text/css" />
        <!-- END PAGE LEVEL PLUGINS -->
        <!-- BEGIN THEME GLOBAL STYLES -->
        <link href="/packs/assets/css/components.min.css" rel="stylesheet" id="style_components" type="text/css" />
        <link href="/packs/assets/css/plugins.min.css" rel="stylesheet" type="text/css" />
        <!-- END THEME GLOBAL STYLES -->
        <!-- BEGIN THEME LAYOUT STYLES -->
        <link href="/packs/assets/layouts/layout.min.css?v=1.0" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/layouts/light.min.css" rel="stylesheet" type="text/css" id="style_color" />
        <!-- END THEME LAYOUT STYLES --> 
        <link href="/packs/assets/bootstrap-select/css/bootstrap-select.min.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/css/bootstrap-modal-bs3patch.css" rel="stylesheet" type="text/css" />
        <link href="/packs/assets/css/bootstrap-modal.css" rel="stylesheet" type="text/css" />
        <link href="/packs/static/css/hack.css" rel="stylesheet" type="text/css"/>
		<style>
	.dropdown-menu li {
				border-bottom: 1px solid #ccc;
				padding: 8px;
			}
  </style>

    </head>
    <body class="page-container-bg-solid page-header-fixed page-sidebar-closed-hide-logo">
            <div class="page-header navbar navbar-fixed-top">
            <div class="page-header-inner ">
			<?php
			$type_vips = $user->vip;
			if($type_vips == 1)
			{
				$vips = '<font color=#f60><i class="fa fa-star"></i> VIP member</font>';
			}
			else
			{
				$vips = '<font color=#080>Normal member</font>';
			}
                    ?>
                <div class="page-logo">
                    <a href="<?=links('vod')?>"><img src="/packs/assets/img/logo.png" alt="logo" class="logo-default" /></a>
                </div>
                <a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse"> </a>
                <div class="page-top">
                    <div class="layui-form search-form open" action="">
                        <div class="input-group">
                        	<input type="text" name="key" id="key" class="form-control input-sm" placeholder="Please enter a video title..." value="">
                            <span class="input-group-btn">
                                <a href="javascript:;" class="btn submit searchbut" link="<?=links('vod','search')?>">
                                    <i class="icon-magnifier"></i>
                                </a>
                            </span>
                        </div>
                    </div>
               		<div id="cscms_login" class="top-menu"> 
                        <ul class="nav navbar-nav pull-right">
                            <li class="dropdown dropdown-user dropdown-dark">
                                <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
                                <span class="username username-hide-on-mobile" id="user-name" style="color: #ffcc00;"><i class="fa fa-user"></i><?= strtoupper($user->name) ?></span>
                                <img alt="<?=$user->name?>" src="/packs/assets/img/nan_nopic.jpg" class="img-circle"></a>
                            </li>
	<?php
$addtime = $user->addtime; // giả sử $user->addtime chứa thời gian tham gia dưới dạng timestamp UNIX.
$formattedDate = date("d-m-Y", $addtime);
?>
<script src="/packs/jquery/jquery.min.js"></script>
<script>document.addEventListener("DOMContentLoaded",function(){var inputField=document.getElementById("key");inputField.addEventListener("keypress",function(event){if(event.key==="Enter"){event.preventDefault();performSearch()}});document.querySelector(".searchbut").addEventListener("click",function(event){event.preventDefault();performSearch()});function performSearch(){var searchValue=inputField.value.trim();var searchLink=document.querySelector(".searchbut").getAttribute("link");if(searchValue!==""){window.location.href=searchLink+"?key="+encodeURIComponent(searchValue)}else{}}});</script><script type="text/javascript">$(document).ready(function(){var userNameSpan=$("#user-name, .img-circle");var dropdownMenu=$("<ul>").addClass("dropdown-menu").css("z-index","9999");var items=[{label:"<font style='font-weight:bold;'>Account:</font>",value:'<td class="hide"><?php { echo $vips; }?></td>'},{label:"",value:'Accout settings',link:"<?=links('info', 'edit')?>"},{label:"",value:'Change password',link:"<?=links('info', 'pass')?>"},{label:"",value:'Login log',link:"<?=links('info', 'log')?>"},{label:"<font style='font-weight:bold;'>Join date:</font>",value:'<font style="color: red; font-weight: bold;"><?php echo $formattedDate; ?></font>'},{label:"",value:'<i class="fa fa-sign-out"></i> Logout',link:"<?=links('login','ext')?>"}];items.forEach(function(item){var listItem=$("<li>");var link=$("<a>");if(item.link){link.attr("href",item.link)}else{link.attr("href","#")}
var span=$("<span>").html(item.label+" <font style='font-weight:bold;'>"+item.value+"</font>");link.append(span);listItem.append(link);dropdownMenu.append(listItem)});dropdownMenu.hide();userNameSpan.click(function(){dropdownMenu.toggle();var offset=userNameSpan.offset();var dropdownTop=offset.top-dropdownMenu.outerHeight();if(dropdownTop>=$(".page-header").offset().top){dropdownMenu.css({top:dropdownTop,left:offset.left-dropdownMenu.width()+userNameSpan.outerWidth()})}else{dropdownMenu.css({top:offset.top+userNameSpan.outerHeight(),left:offset.left-dropdownMenu.width()+userNameSpan.outerWidth()})}});$("body").append(dropdownMenu);$(document).on("click",function(event){if(!$(event.target).closest("#dropdown-icon, .dropdown-menu").length){if(dropdownMenu.is(":visible")){dropdownMenu.hide();userNameSpan.removeClass("rotate-icon")}}})});</script>
                          <!---li class="dropdown dropdown-extended dropdown-notification dropdown-dark">
                                <a href="<?=links('login','ext')?>" class="dropdown-toggle">
                                    <div class="icon-container">
                                    <i class="fa fa-sign-out"></i>
								</div>
                                </a>
                            </li--->
                        </ul>
                   </div>
                </div>
            </div>
        </div>
        <div class="clearfix"> </div>
        <div class="page-container">
 <div class="page-sidebar-wrapper">
	<div class="page-sidebar navbar-collapse collapse">
		<ul class="page-sidebar-menu" data-keep-expanded="true" data-auto-scroll="true" data-slide-speed="200">
			<li class="nav-item start active open" id="a0">
			<a href="javascript:;" class="nav-link nav-toggle">
			<i class="fa fa-file-video-o"></i>
			<span class="title">Cloud disk</span>
			<span class="arrow"></span>
			</a>
			<?php $currentUrl = str_replace('/index.php','', current_url()); ?>
			<ul class="sub-menu">
                <li class="nav-item <?= $currentUrl == links('/upload') ? 'active': ''; ?>" id="a10">
                <a href="<?=links('upload')?>" class="nav-link ">
                <i class="fa fa-cloud-upload"></i>
                <span class="title">Upload video</span>
                </a>
                </li>
				<li class="nav-item <?= $currentUrl == links('vod') ? 'active': ''; ?>" id="a3">
				<a href="<?=links('vod')?>" class="nav-link ">
				<i class="fa fa-folder-open"></i>
				<span class="title">My video</span>
				<span class="badge badge-success"> <?=$this->csdb->get_nums('vod',array('uid'=>$user->id))?> </span>
				</a>
				</li>
				<li class="nav-item <?= $currentUrl == links('lists') ? 'active': ''; ?>" id="a4">
				<a href="<?=links('lists')?>" class="nav-link ">
				<i class="fa fa-film"></i>
				    <span class="title">My category</span>
				</a>
				</li>
				<li class="nav-item <?= $currentUrl == links('info','docs') ? 'active': ''; ?>"  id="a6">
					<a href="<?=links('info','docs')?>" class="nav-link">
					<i class="fa fa-key"></i>
					<span class="title"> Documents</span>
					</a>
				</li>
				<li class="heading"></li>
				<li class="nav-item"  id="a6">
				<a href="https://t.me/" class="nav-link" target="_blank">
				<i class="fa fa-telegram"></i>
				<span class="title"> Customer service</span>
				</a>
				</li>
				<li class="nav-item"  id="a7">
				<a href="https://t.me/" class="nav-link" target="_blank">
				<i class="fa fa-money"></i>
				<span class="title"> Contact advertising</span>
				</a>
				</li>
			</ul>
			</li>
		</ul>
	</div>
</div>
