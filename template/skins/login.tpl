<!DOCTYPE html>
<html>

<head>
    <style>
        .container {
            padding-top: 60px;
        }

        .layui-input-block input::placeholder {
            color: rgba(255, 255, 255, 0.5);
            /* Màu trắng mờ */
            font-style: italic;
            font-size: 12px;
        }

        .register-tis {
            display: block;
            margin-top: 10px;
            margin-left: auto;
            margin-right: auto;
            width: fit-content;
            color: #fff;
            cursor: pointer;
        }

        .register-tis:hover {
            color: #2986cc;
        }

        .password-container {
            position: relative;
        }

        .password {
            padding-right: 30px;
            /* Để tạo không gian cho eye icon */
        }

        .password-toggle {
            position: absolute;
            right: 5px;
            /* Có thể điều chỉnh khoảng cách theo ý muốn */
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
        }
        .remember_me {
        margin-left: 120px; 
        display: flex;
        align-items: center;
        margin-bottom: 16px;
        }

        .remember_me input[type="checkbox"] {
        margin-right: 8px !important;
        width: 14px !important;
        height: 14px !important;
        accent-color: #007bff !important;
        }

        .remember_me label {
        font-size: 14px;
        color: smoke;
        vertical-align: middle;
        }
    </style>
    <meta charset=utf-8>
    <title>
        <?=$title?>
    </title>
    <meta name="robots" content="noindex,nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="<?=Web_Path?>packs/font/font.css">
    <link rel="stylesheet" href="<?=Web_Path?>packs/admin/css/style.css">
    <link rel="stylesheet" href="<?=Web_Path?>packs/layui/css/layui.css">
    <link type="text/css" rel="stylesheet" href="<?=Web_Path?>packs/admin/css/login.css?v=1" />
    <link rel="icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/packs/assets/img/favicon.ico" type="image/x-icon">
    <script src="<?=Web_Path?>packs/layui/layui.js"></script>
    <script src="<?=Web_Path?>packs/jquery/jquery.min.js"></script>
</head>

<body class="login">
    <section class="container">
        <div class="login-container">
            <div class="circle circle-one"></div>
            <div class="form-container">
                <img src="<?=Web_Path?>packs/admin/images/illustration.png" alt="illustration" class="illustration" />
                <div class="login-title">Login</div>
                <form class="layui-form login-form" action="<?=links('login/save')?>" method="post">
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-block username-container">
                            <input type="text" name="name" id="nameField" class="username" placeholder="Username" autocomplete="off" />
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-block password-container">
                            <input type="password" name="pass" class="password" id="passwordField"
                                placeholder="Password" oncontextmenu="return false" onpaste="return false" />
                            <span id="togglePassword" class="password-toggle" onclick="togglePasswordVisibility()">
                                <img id="eyeIcon" src="/packs/assets/img/eye-icon.png" alt="Show Password">
                            </span>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-block password-container">
                            <p id="capsLockWarning" style="display: none;"><i class="fa fa-exclamation-triangle"
                                    style="color: yellow" aria-hidden="true"></i> Caps Lock is on!</p>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-block password-container">
                            <input type="text" name="otp" class="password" id="otpField"
                                placeholder="Otp" oncontextmenu="return false" disabled=""/>
                        </div>
                    </div>
                    <!-- Display secure code (old version)
                    <div class="layui-form-item">
                        <label class="layui-form-label"></label>
                        <div class="layui-input-block">
                            <input type="password" name="code" class="text" placeholder="Verification code"
                                oncontextmenu="return false" onpaste="return false" />
                            <img src="<?=links('code')?>" onclick="this.src=this.src+'?'" class="verifyimg">
                        </div>
                    </div> -->
                    <div class="remember_me">
                            <input type="checkbox" id="remember_me" name="remember_me">
                            <label for="remember_me">Remember Me</label>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="opacity" lay-submit lay-filter="login" id="loginButton">Send OTP</button>
                        </div>
                    </div>
                </form>
                <a href="/forgot">
                    <span class="register-tis">Forgot Password</span>
                </a>
                <div class="circle circle-two"></div>
            </div>
            <div class="theme-btn-container"></div>
    </section>
    <script src="<?=Web_Path?>packs/admin/js/common.js"></script>
    <script src="<?=Web_Path?>packs/admin/js/script.js"></script>
    <script>document.addEventListener('DOMContentLoaded', function () { var inputs = document.querySelectorAll('.layui-input'); inputs.forEach(function (input) { input.addEventListener('input', function () { input.parentNode.classList.toggle('has-content', input.value.length > 0) }) }) });</script>
    <script>document.getElementById("loginForm").addEventListener("keyup", function (event) { if (event.key === "Enter") { event.preventDefault(); document.getElementById("submit").click() } });</script>
    <script>function togglePasswordVisibility() { var passwordField = document.getElementById("passwordField"); var eyeIcon = document.getElementById("eyeIcon"); if (passwordField.type === "password") { passwordField.type = "text"; eyeIcon.src = "/packs/assets/img/eye-slash-icon.png"; eyeIcon.alt = "Hide Password" } else { passwordField.type = "password"; eyeIcon.src = "/packs/assets/img/eye-icon.png"; eyeIcon.alt = "Show Password" } }</script>
    <script>document.getElementById("passwordField").addEventListener("keyup", function (event) { var capsLockState = event.getModifierState && event.getModifierState("CapsLock"); var capsLockWarning = document.getElementById("capsLockWarning"); if (capsLockState) { capsLockWarning.style.display = "block" } else { capsLockWarning.style.display = "none" } });</script>
</body>

</html>