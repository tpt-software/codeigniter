<!DOCTYPE html>
<html lang="en">
    <head>
    <title><?=$title?></title>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
    <meta http-equiv="content-language" content="zh-CN" />
    <meta http-equiv="X-UA-Compatible" content="chrome=1" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="expires" content="0" />
    <meta name="referrer" content="never" />
    <meta name="renderer" content="webkit" />
    <meta name="msapplication-tap-highlight" content="no" />
    <meta name="HandheldFriendly" content="true" />
    <meta name="x5-page-mode" content="app" />
    <meta name="Viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0" />    
    <link rel="stylesheet" href="/packs/dp/DPlayer.min.css" type="text/css" />
    <style type="text/css">*{margin: 0;padding: 0;font-family: "Microsoft YaHei",SimHei,"Helvetica Neue",Helvetica,Arial,sans-serif;font-size:13px;}img{border: 0;}a{color:inherit;text-decoration: none;color:#4B7E9D;}a:hover{text-decoration: underline;}body{background:#000;padding: 0;margin: 0;width:100%;height:100%;color:#fff;overflow:hidden;cursor: default;}.error{position:absolute;width:100%;height:100%;text-align:center;top:50%;margin:-30px 0 0 0;z-index:10;}.player,#dpplayer{position:absolute;width:100%;height:100%;}.dplayer-menu{display:none !important;}.torrentnum{padding: 5px;position: absolute;font-size: 12px;}</style>
    <script type="text/javascript" src="/packs/dp/flv.min.js"></script>
    <script type="text/javascript" src="/packs/dp/hls.min.js"></script>
    <script type="text/javascript" src="/packs/dp/DPlayer.min.js"></script>
    <script type="text/javascript">
    var wap = navigator.userAgent.match(/iPad|iPhone|Android|Linux|iPod/i) != null;
    window.onload = function(){
        var dp = new DPlayer({
            container:document.getElementById('dpplayer'),
             autoplay:true,
             allowfullscreen:true,
             video:{
                quality:[{
                    type:'hls',
                    name:'14412882.COM',
                    url:'<?=$m3u8url?>'
                  }],
                defaultQuality:0
            }
        });
        if(wap){
            var play = document.getElementById('divBag');
            play.onclick=function(){
                dp.play();
                play.style.display = 'none';
                document.getElementById('dpplayer').style.display = 'block';
            }
        }else{
            document.getElementById('divBag').style.display = 'none';
            document.getElementById('dpplayer').style.display = 'block';
            dp.play();
        }
    };
    </script>
    <body>
    <div id="dpplayer" style="display: none;"></div>
    <div class="content" id="divBag" style="position: fixed;left: 0px;top: 0px;z-index: 1;background-image: url(/packs/dp/play.png);background-repeat: no-repeat;background-position: 50% 50%;width: 100%;height: 100%;"></div>
    </body>
    </html>