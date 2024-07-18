<?php
$DEBUGGING = True;
$TRACECOUNT = 0;
 
if($DEBUGGING)
{
    error_reporting(E_ALL);
    ini_set('display_errors', True);
}
 
function trace($message)
{
    global $DEBUGGING;
    global $TRACECOUNT;
    if($DEBUGGING)
    {
        echo '<hr />;'.$TRACECOUNT++.'<code>'.$message.'</code><hr />';
    }
}
 
function tarr($arr)
{
    global $DEBUGGING;
    global $TRACECOUNT;
    if($DEBUGGING)
    {
        echo '<hr />'.$TRACECOUNT++.'<code>';
        print_r($arr);
        echo '</code><hr />';
    }
}
 
?>
<?php 
$url = isset($_GET['s'])?$_GET['s']: $m3u8url;
//$url = 'https://upload.wikimedia.org/wikipedia/commons/transcoded/7/74/Sprite_Fright_-_Open_Movie_by_Blender_Studio.webm/Sprite_Fright_-_Open_Movie_by_Blender_Studio.webm.1080p.vp9.webm';

$sub_url = isset($_GET['subjson_url'])? $_GET['subjson_url'] : '';

if($sub_url != "")
{
	// Fetch the content from the URL
	$json_sub = file_get_contents($sub_url);

	// Decode the JSON content to an associative array
	$subtitles = json_decode($json_sub, true);
	if($json_sub != "")
	{
		$flag_sub = true;
		$track_sub = "tracks: " . str_replace("\/", "/",$json_sub) . ",";
	}
	else
	{
		$flag_sub = false;
		$track_sub = '';
	}
}
else
{
	$track_sub = '';
}

?>
<?php
function CryptoJSAesEncrypt($passphrase, $plain_text) {
    $salt = openssl_random_pseudo_bytes(256);
    $iv = openssl_random_pseudo_bytes(16);

    $iterations = 999;  
    $key = hash_pbkdf2("sha512", $passphrase, $salt, $iterations, 64);

    $encrypted_data = openssl_encrypt($plain_text, 'aes-256-cbc', hex2bin($key), OPENSSL_RAW_DATA, $iv);
    
    $data = array("ciphertext" => base64_encode($encrypted_data), "iv" => bin2hex($iv), "salt" => bin2hex($salt));
    return json_encode($data);
}
$text = CryptoJSAesEncrypt('Encrypt', $url); 

function ma_hoa_chuoi($chuoi, $khoa) {
                                          $chuoi_ma_hoa = '';
                                          $khoa_length = strlen($khoa);
                                          for ($i = 0; $i < strlen($chuoi); $i++) {
                                           $chuoi_ma_hoa .= $chuoi[$i] ^ $khoa[$i % $khoa_length];
                                                }
                                            
                                                return bin2hex($chuoi_ma_hoa);
                                            }
$khoa = "14412882_top";
function kiem_tra_ios() {
    $user_agent = $_SERVER['HTTP_USER_AGENT'];
    $is_ios = (stripos($user_agent, 'iPhone') !== false) || (stripos($user_agent, 'iPad') !== false);
    
    if ($is_ios) {
        return '&name=14412882.m3u8';
    } else {
        return null;
    }
}



if ($vod->is_remote_m3u8) {
  $m3u8Link = $vod->m3u8_url;
} else {
  $m3u8Link = '/hash.php?hash=' . ma_hoa_chuoi($url, $khoa) . kiem_tra_ios();
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
	<meta name="robots" content="noindex" />
	<meta name="referrer" content="origin">
    <base href="/" />
    <title><?=$title?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="packs/netflix/css/netflix.css">
	<script src="https://ssl.p.jwpcdn.com/player/v/8.34.1/jwplayer.js"></script>
    <script src="/packs/netflix/js/hls.min.js"></script>
    <script src="/packs/netflix/js/jwplayer.hlsjs.min.js"></script>
	<!--meta name="google-adsense-account" content="ca-pub-1132687241975096">
	<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-1132687241975096"
     crossorigin="anonymous"></script-->
     <style type="text/css">html,body{width:100%;height:100%; padding:0; margin:0;}#player-embed,iframe{width:100%;height:100%;}</style>
    <script type="text/javascript">
        jwplayer.key = "ITWMv7t88JGzI0xPwW8I0+LveiXX9SWbfdmt0ArUSyc=";	
    </script>
	<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-5LWD6V4D');</script>
	<!-- End Google Tag Manager -->
	
<script data-cfasync="false" type="text/javascript" src="//clobberprocurertightwad.com/t/9/fret/meow4/2010705/9d21ed73.js"></script>

</head>
<body marginwidth="0" marginheight="0">
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5LWD6V4D"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.2.0/crypto-js.min.js"></script>   


    <div id="player-fake"></div>
    




<script>


	var wap = navigator.userAgent.match(/iPad|iPhone|Android|Linux|iPod/i) != null;
        var playerInstance = jwplayer('player-fake');
        playerInstance.setup({
            file: '<?= $m3u8Link ?>',
            width: '100%',
            height: '100%',
            primary: 'html5',
			type: 'hls',
            controls: true,
			<?php echo $track_sub?>
			
			playbackRateControls: [0.5, 0.75, 1, 1.5, 2],
			logo: {
				file: "",
				logoBar: "",
				link: "https://14412882.com",
				position: "top-left"
			},
            skin: {
             name: "netflix"
                     },
		  sharing: true,
		  displaytitle: true,
		  displaydescription: true,
		  abouttext: "Powered by 14412882.com",
		  aboutlink: "https://14412882.com",           
			autostart: true,
      preload: "auto",
            stretching: "uniform",

             "intl": {
				"en": {
				  "errors": {
					"cantPlayVideo": "Error Video!!! <br> Please note that you must wait 15-30 minutes after upload before you can click to view.<br> Otherwise, video will be cached, you need to delete video and re-upload!<br>14412882.com"
				  }
				}
			  }
        });
        playerInstance.on("ready", function () {
  const buttonId = "download-video-button";
  const iconPath =
    "https://14412882.com/packs/assets/img/logo.png";
  const tooltipText = "14412882.com";

  // Call the player's `addButton` API method to add the custom button
  playerInstance.addButton(iconPath, tooltipText, buttonClickAction, buttonId);

  // This function is executed when the button is clicked
  function buttonClickAction() {
    const playlistItem = playerInstance.getPlaylistItem();
    const anchor = document.createElement("a");
    const fileUrl = playlistItem.file;
    anchor.setAttribute("hef", fileUrl);
    const downloadName = playlistItem.file.split("/").pop();
    anchor.setAttribute("download", downloadName);
    anchor.style.display = "none";
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);
  }


  // Move the timeslider in-line with other controls
  const playerContainer = playerInstance.getContainer();
  const buttonContainer = playerContainer.querySelector(".jw-button-container");
  const spacer = buttonContainer.querySelector(".jw-spacer");
  const timeSlider = playerContainer.querySelector(".jw-slider-time");
	
  // Detect adblock
  playerInstance.on("adBlock", () => {
    const modal = document.querySelector("div.modal");
    modal.style.display = "flex";

    document
      .getElementById("close")
      .addEventListener("click", () => location.reload());
  });

  // Forward 10 seconds
  const rewindContainer = playerContainer.querySelector(
    ".jw-display-icon-rewind"
  );
  const forwardContainer = rewindContainer.cloneNode(true);
  const forwardDisplayButton = forwardContainer.querySelector(
    ".jw-icon-rewind"
  );
  forwardDisplayButton.style.transform = "scaleX(-1)";
  forwardDisplayButton.ariaLabel = "Forward 10 Seconds";
  const nextContainer = playerContainer.querySelector(".jw-display-icon-next");
  nextContainer.parentNode.insertBefore(forwardContainer, nextContainer);

  // control bar icon
  playerContainer.querySelector(".jw-display-icon-next").style.display = "none"; // hide next button
  const rewindControlBarButton = buttonContainer.querySelector(
    ".jw-icon-rewind"
  );
  const forwardControlBarButton = rewindControlBarButton.cloneNode(true);
  forwardControlBarButton.style.transform = "scaleX(-1)";
  forwardControlBarButton.ariaLabel = "Forward 10 Seconds";
  rewindControlBarButton.parentNode.insertBefore(
    forwardControlBarButton,
    rewindControlBarButton.nextElementSibling
  );

  // add onclick handlers
  [forwardDisplayButton, forwardControlBarButton].forEach((button) => {
    button.onclick = () => {
      playerInstance.seek(playerInstance.getPosition() + 10);
    };
  });
});
    </script>
   </body>

</html>