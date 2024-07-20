<!DOCTYPE html>
<!--[if IE 8]> <html lang="en" class="ie8 no-js"> <![endif]-->
<!--[if IE 9]> <html lang="en" class="ie9 no-js"> <![endif]-->
<!--[if !IE]><!-->
<html lang="en">

<head>
    <!--link rel="stylesheet" type="text/css" href="/packs/layui/css/layui.css"-->
    <link rel="stylesheet" type="text/css" href="/packs/admin/css/common.css?v=1.1">
    <link rel="stylesheet" type="text/css" href="/packs/font/font.css">
    <link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <script src="/packs/jquery/jquery.min.js"></script>
    <script src="/packs/layui/layui.js"></script>
    <script src="/packs/admin/js/common.js"></script>
    <script src="/packs/jquery/jquery.min.js"></script>
    <script src="/packs/layui/layui.js"></script>
    <style>
        .form-group-tele {
            text-align: center;
        }

        .contact-tele {
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
        }

        .link-wrapper {
            display: inline-block;
        }

        .vip-status {
            color: #080;
            font-weight: bold;
        }

        .vip-status.vip {
            color: #f60;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <?php 
$vips = $user->vip;
 
if($vips==1){
	$vips = 'VIP member';
}  
else
{
	$vips = 'Normal member';
}
?>
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div class="col-md-12">
                    <div class="portlet light bordered">
                        <center><span style="font-size: 12px; color:red; font-weight: bold; text-transform: uppercase;">
                                Warning: Update new backup domain <a href="https://14412882.net"
                                    target="_blank">14412882.net</a>, please replace the new domain in your database,
                                Thank you!</span></center>
                    </div>
                    <div class="portlet light portlet-fit portlet-form bordered">
                        <div class="portlet-title">
                            <div class="caption">
                                <span class="caption-subject font-red sbold uppercase">Modify user &nbsp;</span>
                            </div>
                        </div>
                        <div class="portlet-body">
                            <div class="form-body">

                                <form class="layui-form form-horizontal" method="post"
                                    action="<?=links('info','save','edit')?>">
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Account
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input class="form-control" type="text" value="<?=$user->name?>" disabled>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="control-label col-md-3">Account Type
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input
                                                class="form-control vip-status <?=$vips == 'VIP member' ? 'vip' : 'normal' ?>"
                                                type="text" value="<?=$vips?>" disabled>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-3">API Key
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input class="form-control" type="text" value="<?=$user->apikey?>" disabled>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Mail
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input type="text" name="email" required lay-verify="email"
                                                placeholder="Please enter your email" autocomplete="off"
                                                class="form-control" value="<?=$user->email?>" disabled>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Join Date</label>
                                        <div class="col-md-6">
                                            <input class="form-control" type="text" value="<?= date(" d-m-Y",
                                                $user->addtime) ?>" disabled>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-3">URL domain
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input type="text" name="url" required lay-required=""
                                                placeholder="Please enter your domain name" value="<?=$user->url?>"
                                                class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="control-label col-md-3">Telegram
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6">
                                            <input type="text" class="form-control" name="telegram"
                                                placeholder="Please enter your Telegram" value="<?=$user->telegram?>">
                                        </div>
                                    </div>
                                    <?php if(Is_OTP == 1): ?> 
                                    <div class="form-group">
                                        <label class="control-label col-md-3">
                                            <span class="required"> </span>
                                        </label>
                                        <div class="col-md-6 form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="is_otp" id="is_otp" <?= $user->is_otp == 1 ? 'checked' : '' ?> >
                                            <label class="form-check-label" for="is_otp">Require OTP when logging in</label>
                                        </div>
                                    </div>
                                    <?php endif ?> 
                                    <div class="form-group-tele">
                                        <label class="contact-tele">
                                            <span class="link-wrapper">
                                                <a href="https://t.me/+qH8JONlo_LI4M2Q9" target="_blank">
                                                    <span style="color: #357ebd;"><i class="fa fa-telegram"></i>
                                                        Telegram Support Group</span>
                                                </a>
                                            </span>
                                        </label>
                                        <div class="col-md-6">
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <div class="row">
                                            <div class="col-md-offset-3 col-md-9">
                                                <button type="submit" lay-submit lay-filter="*"
                                                    class="btn btn-lg green"><i class="fa fa-check"></i> Submit
                                                </button>
                                                <button type="reset" class="btn btn-lg grey-salsa btn-outline"><i
                                                        class="fa fa-refresh"></i> Reset</button>
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
            $('#b3').addClass('active');
            $('#b2').addClass('open');
            $("#idall").css('display', 'block');
        </script>

</body>