<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "https://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="https://www.w3.org/1999/xhtml">

<head>
    <link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Sign Up -
        <?=Web_Name?> - Free multimedia cloud disk system - WWW.14412882.com
    </title>
    <meta name="keywords" content="Cloud disk storage, cloud transcoding, permanent free CDN multimedia network disk" />
    <meta name="description"
        content="Cloud disk storage, cloud transcoding, permanent free CDN multimedia network disk" />
    <link rel="stylesheet" href="/packs/static/css/style.css" />
    <link rel="stylesheet" href="<?=Web_Path?>packs/assets/font-awesome/css/font-awesome.css">
    <script src="/packs/static/js/jquery.min.js"></script>
    <script src="<?=Web_Path?>packs/layer/layer.js"></script>
    <style>
    .layui-layer-hui{
            background-color: #fff;
    }
        .copyright-reg {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            padding: 10px;
            width: 100%;
            text-align: center
        }

        .confirm-password-container {
            display: flex;
            align-items: center;
            width: 310px
        }

        .confirm-password {
            flex: 1;
            margin-right: 5px
        }

        .password-toggle {
            cursor: pointer
        }

        .password-toggle img {
            vertical-align: middle;
            margin-top: 25px
        }

        .password-container {
            display: flex;
            align-items: center;
            width: 310px
        }

        .password {
            flex: 1;
            margin-right: 5px
        }

        .password-toggle {
            cursor: pointer
        }

        .password-toggle img {
            vertical-align: middle;
            margin-top: 25px
        }

        .form-container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: rgb(248 248 248 / .15);
            border: 2px solid #ccc;
            padding: 20px;
            border-radius: 10px;
            width: 500px;
            height: 600px
        }

        .username-container {
            position: relative
        }

        .username-container input.username {
            padding-right: 30px
        }

        .username-container i {
            position: absolute;
            top: 70%;
            right: 5px;
            transform: translateY(-50%);
            font-size: 20px;
            color: #fff
        }

        .is_notification {
        display: flex;
        align-items: center;
        margin-bottom: 16px;
        }

        .is_notification input[type="checkbox"] {
        margin-right: 8px;
        width: 18px;
        height: 18px;
        accent-color: #007bff;
        }

        .is_notification label {
        font-size: 14px;
        color: white;
        margin-top: 22px;
        }
    </style>

<body>
    <div class="login-container">
        <div class="box">
            <div class="form-container">
                <h1>
                    <a href="https://14412882.com"><img src="/packs/static/picture/logo.png" alt=""></a>
                </h1>
                <div class="connect">
                    <p>Free multimedia cloud disk system</p>
                </div>

                <form action="<?=links('reg','save')?>" method="post" id="registerForm">
                    <div class="username-container">
                        <input type="text" name="name" class="username" placeholder="Username" autocomplete="off" />
                        <i class="fa fa-user"></i>
                    </div>
                    <div class="password-container">
                        <input type="password" name="pass" class="password" id="passwordField" placeholder="Password"
                            oncontextmenu="return false" onpaste="return false" />
                        <span id="togglePassword" class="password-toggle" onclick="togglePasswordVisibility()">
                            <img id="eyeIcon" src="/packs/assets/img/eye-icon.png" alt="Show Password">
                        </span>
                    </div>
                    <br>
                    <p id="capsLockWarning" style="display: none;"><i class="fa fa-exclamation-triangle"
                            style="color: yellow" aria-hidden="true"></i> Caps Lock is on!</p>
                    <div>
                        <input type="password" name="repass" class="confirm_password" id="confirmPasswordField"
                            placeholder="Confirm Password" oncontextmenu="return false" onpaste="return false" />
                    </div>
                    <br>
                    <p id="confirmCapsLockWarning" style="display: none;"><i class="fa fa-exclamation-triangle"
                            style="color: yellow" aria-hidden="true"></i> Caps Lock is on!</p>
                    <div>
                        <input type="email" name="email" class="email" placeholder="Email" />
                    </div>
                    <div class="is_notification">
                        <input type="checkbox" id="is_notification" name="is_notification">
                        <label for="is_notification">Agree to receive email notifications</label>
                    </div>
                    <!---div style="position: relative;"> <input type="text" name="code" class="password" placeholder="Verification code"  />
                    <img src="<?=links('code')?>" onclick="this.src=this.src+'?'" class="verifyimg"> </div--->
                    <span id="submit" class="u-btn">Sign Up</span>
                </form>
                <a href="<?=links('login')?>" class="to-login">
                    <button type="button" class="register-tis">Already have an account?</button>
                </a>
            </div>
            <p class="copyright-reg">
                <script>
                    document.write(new Date().getFullYear());
                </script>&copy; all rights reserved
                <span>14412882.com</span>&nbsp;|&nbsp;Multimedia cloud disk system
            </p>
            <!--Automatic background image replacement-->
            <script src="/packs/static/js/supersized.3.2.7.min.js"></script>
            <script src="/packs/static/js/common.js"></script>
            <script>function togglePasswordVisibility() { var passwordField = document.getElementById("passwordField"); var eyeIcon = document.getElementById("eyeIcon"); if (passwordField.type === "password") { passwordField.type = "text"; eyeIcon.src = "/packs/assets/img/eye-slash-icon.png"; eyeIcon.alt = "Hide Password" } else { passwordField.type = "password"; eyeIcon.src = "/packs/assets/img/eye-icon.png"; eyeIcon.alt = "Show Password" } }</script>
            <script>document.getElementById("passwordField").addEventListener("keyup", function (event) { var capsLockState = event.getModifierState && event.getModifierState("CapsLock"); var capsLockWarning = document.getElementById("capsLockWarning"); if (capsLockState) { capsLockWarning.style.display = "block" } else { capsLockWarning.style.display = "none" } }); document.getElementById("confirmPasswordField").addEventListener("keyup", function (event) { var capsLockState = event.getModifierState && event.getModifierState("CapsLock"); var confirmCapsLockWarning = document.getElementById("confirmCapsLockWarning"); if (capsLockState) { confirmCapsLockWarning.style.display = "block" } else { confirmCapsLockWarning.style.display = "none" } });</script>
</body>

</html>