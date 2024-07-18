<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">
    <head>
		<link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
		<link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <title>Forgot password - <?=Web_Name?> - Free multimedia cloud disk system - WWW.14412882.com</title>
        <meta name="keywords" content="Cloud disk storage, cloud transcoding, permanent free CDN multimedia network disk"/>
        <meta name="description" content="Cloud disk storage, cloud transcoding, permanent free CDN multimedia network disk"/>
        <link rel="stylesheet" href="/packs/static/css/style.css"/>
        <script src="/packs/static/js/jquery.min.js"></script>
        <script src="<?=Web_Path?>packs/layer/layer.js"></script>
    <body>
        <div class="login-container">
	    <div class="box">
            <h1>
                <img src="/packs/static/picture/logo.png" alt="">
            </h1>
            <div class="connect">
                <p>Free multimedia cloud disk system</p>
            </div>

            <form action="<?=links('forgot','save')?>" method="post" id="registerForm">                
                <div>
                    <input type="email" name="email" class="email" placeholder="Email" />
                </div>
                <div style="position: relative;"> <input type="text" name="code" class="password" placeholder="Verification code"  />
                    <img src="<?=links('code')?>" onclick="this.src=this.src+'?'" class="verifyimg"> </div>
                <span id="submit" class="u-btn">Send</span>
            </form>
            <a href="<?=links('login')?>" class="to-login">
                <button type="button" class="register-tis">Already have an account?</button>
            </a>


            <p class="copyright-reg">
                <script>
                    document.write(new Date().getFullYear());
                </script>&copy; all rights reserved
               <span>14412882.com</span>&nbsp;|&nbsp;Multimedia cloud disk system</p>
        </div>
        <!--Automatic background image replacement-->
        <script src="/packs/static/js/supersized.3.2.7.min.js"></script>
        <script src="/packs/static/js/common.js"></script>
    </body>
</html>