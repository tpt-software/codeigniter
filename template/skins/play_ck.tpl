<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <title>
        <?=$title?>
    </title>

    <style type="text/css">
        body,
        html,
        .dplayer {
            padding: 0;
            margin: 0;
            width: 100%;
            height: 100%;
            color: #aaa;
            background-color: #000;
        }

        a {
            text-decoration: none;
        }
    </style>
    <script src="/packs/dplayer/dist/hls.min.js"></script>
    <script src="/packs/dplayer/dist/DPlayer.min.js"></script>
    <link rel="stylesheet" href="/packs/dplayer/dist/DPlayer.min.css">
	
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-J1QK7MQ807"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-J1QK7MQ807');
</script>
</head>

<body onload="play()">
    <div id="dplayer"></div>
</body>

<script>
    var vurl = '<?=$m3u8url?>';
    const dp = new DPlayer({
        container: document.getElementById('dplayer'),
        live: false,
        danmaku: false,
        autoplay: true,
        loop: true,
        screenshot: true,
        hotkey: true,
        preload: 'auto',
        poster: '<?=$picurl?>',
        video: {
            url: vurl,
            type: 'hls'
        }
    });

    function play() {
        dp.play();
    }

</script>

</html>