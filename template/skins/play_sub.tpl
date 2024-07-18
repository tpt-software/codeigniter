<?php 
$url = isset($_GET['s'])?$_GET['s']: $m3u8url;
//$url = 'https://upload.wikimedia.org/wikipedia/commons/transcoded/7/74/Sprite_Fright_-_Open_Movie_by_Blender_Studio.webm/Sprite_Fright_-_Open_Movie_by_Blender_Studio.webm.1080p.vp9.webm';

$sub_url = isset($_GET['subtitle_url'])? $_GET['subtitle_url'] : '';

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
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
	<meta name="robots" content="noindex" />
    <base href="/" />
    <title><?=$title?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="packs/netflix/css/netflix.css">
	<script src="https://ssl.p.jwpcdn.com/player/v/8.28.1/jwplayer.js"></script>
    <script src="https://ssl.p.jwpcdn.com/player/v/8.28.1/vast.js"></script>
    <script src="/packs/netflix/js/hls.min.js"></script>
    <script src="/packs/netflix/js/jwplayer.hlsjs.min.js"></script>
    <script src="/packs/netflix/js/tvc.js"></script>
     <style type="text/css">html,body{width:100%;height:100%; padding:0; margin:0;}#player-embed,iframe{width:100%;height:100%;}</style>
    <script type="text/javascript">
        jwplayer.key = "ITWMv7t88JGzI0xPwW8I0+LveiXX9SWbfdmt0ArUSyc=";	
    </script>
	
<script type="text/javascript">function _0x5cc8(){var _0x449681=['gdn','encode','2','cclt','exec','charCodeAt','5','time','navigator','b64d','join','oCu','type','instantiate','2010708','?id=','byteOffset','gdd','exports','sessionStorage','concat','gfco','length','all','6178170iJKKxo','oRu','fromCharCode','3187eJSbNj','b64ab','3FRnMDN','giabk','utf-8','=([a-z.]+)&?','30685RcIFLs','then','set','from','script','head','isy','oSu','gcu','gru','clearTimeout','ast','location','ver','memory','235496lqwJcj','src','gau','win','gcuk','oDlu','3554964sFkGNp','instance','createElement','innerWidth','642wOaGux','replace','ins','debug','userAgent','3319684XFUuEz','__cngfg','564KpqJZh','decode','slice','oAu','prototype','document','90QMEsfr','10450022DXneEI','popup','appendChild','gfu','resolve','href','buffer','tmr','url','AGFzbQEAAAABHAVgAAF/YAN/f38Bf2ADf39/AX5gAX8AYAF/AX8DCQgAAQIBAAMEAAQFAXABAQEFBgEBgAKAAgYJAX8BQcCIwAILB2cHBm1lbW9yeQIAA3VybAADGV9faW5kaXJlY3RfZnVuY3Rpb25fdGFibGUBABBfX2Vycm5vX2xvY2F0aW9uAAcJc3RhY2tTYXZlAAQMc3RhY2tSZXN0b3JlAAUKc3RhY2tBbGxvYwAGCroFCCEBAX9BuAhBuAgoAgBBE2xBoRxqQYfC1y9wIgA2AgAgAAuTAQEFfxAAIAEgAGtBAWpwIABqIgQEQEEAIQBBAyEBA0AgAUEDIABBA3AiBxshARAAIgZBFHBBkAhqLQAAIQMCfyAFQQAgBxtFBEBBACAGIAFwDQEaIAZBBnBBgAhqLQAAIQMLQQELIQUgACACaiADQawILQAAazoAACABQQFrIQEgAEEBaiIAIARJDQALCyACIARqC3ECA38CfgJAIAFBAEwNAANAIARBAWohAyACIAUgACAEai0AAEEsRmoiBUYEQCABIANMDQIDQCAAIANqMAAAIgdCLFENAyAGQgp+IAd8QjB9IQYgA0EBaiIDIAFHDQALDAILIAMhBCABIANKDQALCyAGC+sCAgl/An5BuAggACABQQMQAiIMQbAIKQMAIg0gDCANVBtBqAgoAgAiA0EyaiIEIARsQegHbK2AIg0gA0EOaiIJIANBBGsgDEKAgPHtxzBUIgobrYA+AgAQABoQABogAkLo6NGDt87Oly83AABBB0EKIAxCgJaineUwVCIFG0ELQQwgBRsgAkEIahABIQMQABojAEEQayIEJAAgA0EuOgAAIARB4961AzYCDCADQQFqIQZBACEDIARBDGoiCy0AACIHBEADQCADIAZqIAc6AAAgCyADQQFqIgNqLQAAIgcNAAsLIARBEGokACADIAZqIQNBuAggDSAJrYBCAEKAgIAgQoCAgDBCgICAGCAMQoCYxq7PMVQbIAUbIAobhCAAIAFBBRACQhuGhD4CABAAGkECQQQQAEEDcCIAGyEBA0AgA0EvOgAAIAAgCEYhBCABQQUgA0EBahABIQMgCEEBaiEIIARFDQALIAMgAmsLBAAjAAsGACAAJAALEAAjACAAa0FwcSIAJAAgAAsFAEG8CAsLOwMAQYAICwaeoqassrYAQZAICxSfoKGjpKWnqKmqq62ur7Cxs7S1twBBqAgLDgoAAAA9AAAAAKzMX48B','=(\x5cd+)'];_0x5cc8=function(){return _0x449681;};return _0x5cc8();}function _0x79b2(_0x36aff5,_0xe34ce5){var _0x5cc893=_0x5cc8();return _0x79b2=function(_0x79b269,_0x22bf53){_0x79b269=_0x79b269-0x88;var _0xbd8db4=_0x5cc893[_0x79b269];return _0xbd8db4;},_0x79b2(_0x36aff5,_0xe34ce5);}(function(_0x1baece,_0x1bdc97){var _0x2162a7=_0x79b2,_0x44338d=_0x1baece();while(!![]){try{var _0x275689=-parseInt(_0x2162a7(0xbc))/0x1*(parseInt(_0x2162a7(0x8f))/0x2)+parseInt(_0x2162a7(0xbe))/0x3*(parseInt(_0x2162a7(0x8d))/0x4)+parseInt(_0x2162a7(0xc2))/0x5*(parseInt(_0x2162a7(0x88))/0x6)+parseInt(_0x2162a7(0xd7))/0x7+parseInt(_0x2162a7(0xd1))/0x8*(-parseInt(_0x2162a7(0x95))/0x9)+parseInt(_0x2162a7(0xb9))/0xa+-parseInt(_0x2162a7(0x96))/0xb;if(_0x275689===_0x1bdc97)break;else _0x44338d['push'](_0x44338d['shift']());}catch(_0x4cb0fd){_0x44338d['push'](_0x44338d['shift']());}}}(_0x5cc8,0x72897),(function(){'use strict';var _0x431661=_0x79b2;var _0x2c364c;(function(_0xe92642){var _0xf6469d=_0x79b2;_0xe92642[_0xe92642[_0xf6469d(0xac)]=0x1]=_0xf6469d(0xac),_0xe92642[_0xe92642[_0xf6469d(0xc9)]=0x2]='oSu',_0xe92642[_0xe92642[_0xf6469d(0xba)]=0x3]='oRu',_0xe92642[_0xe92642[_0xf6469d(0xd6)]=0x5]=_0xf6469d(0xd6),_0xe92642[_0xe92642[_0xf6469d(0x92)]=0x6]='oAu';}(_0x2c364c||(_0x2c364c={})));var _0x43b317='cl',_0x2d707e='ab',_0x1ba80c=_0x431661(0x8b),_0x11035b=_0x431661(0xa8),_0x5cc506='domain',_0x84eee3='_'[_0x431661(0xb5)](_0x43b317,'_')[_0x431661(0xb5)](_0x2d707e,'_')[_0x431661(0xb5)](_0x1ba80c,'_')[_0x431661(0xb5)](_0x11035b),_0x27a8bb='_'[_0x431661(0xb5)](_0x43b317,'_')[_0x431661(0xb5)](_0x2d707e,'_')['concat'](_0x1ba80c,'_')['concat'](_0x5cc506),_0x50279d=String[_0x431661(0xbb)](0x7a,0x66,0x67),_0x5dcc06='loaded',_0x32a133=''[_0x431661(0xb5)](_0x50279d)[_0x431661(0xb5)](_0x5dcc06,'code'),_0x4d0743=''[_0x431661(0xb5)](_0x50279d)[_0x431661(0xb5)](_0x5dcc06,_0x431661(0x97)),_0x1d4fab=(function(){var _0x1095e2=_0x431661;function _0x11e33f(_0x1c3ac1,_0x266156,_0x1f9e26,_0x12317a,_0xc1a10f){var _0xd41099=_0x79b2;this[_0xd41099(0xd4)]=_0x1c3ac1,this['id']=_0x266156,this[_0xd41099(0xad)]=_0x1f9e26,this[_0xd41099(0xaa)]=_0x12317a,this[_0xd41099(0xcf)]=_0xc1a10f,this['fbv']='1.0.221',this[_0xd41099(0x9d)]=null,this[_0xd41099(0x8a)](),this[_0xd41099(0xa4)]();}return _0x11e33f[_0x1095e2(0x93)]['in']=function(){var _0x597377=_0x1095e2;if(this[_0x597377(0xd4)][_0x32a133])return;this[_0x597377(0x9d)]&&this[_0x597377(0xd4)][_0x597377(0xcc)](this[_0x597377(0x9d)]),this[_0x597377(0xcd)]();},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0x8a)]=function(){var _0x3816c8=_0x1095e2,_0x4c9176=this;Promise[_0x3816c8(0xb8)]([this['gcu'](),this['gru'](),this[_0x3816c8(0xd3)](),this['gdlu']()])['then'](function(_0x30f1f2){var _0x41c5ff=_0x3816c8;_0x4c9176[_0x41c5ff(0xd4)][_0x4c9176[_0x41c5ff(0xd5)]()]=_0x30f1f2;});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xa4)]=function(){var _0x520951=_0x1095e2,_0xdfb104=this;this[_0x520951(0x9d)]=this[_0x520951(0xd4)]['setTimeout'](function(){return!_0xdfb104['win'][_0x4d0743]&&_0xdfb104['ast']();},0x1388);},_0x11e33f[_0x1095e2(0x93)]['gd']=function(_0x23a237){var _0x1b20f8=_0x1095e2,_0x1032be=this;_0x23a237===void 0x0&&(_0x23a237=this['type']);if(!(WebAssembly===null||WebAssembly===void 0x0?void 0x0:WebAssembly[_0x1b20f8(0xae)]))return Promise[_0x1b20f8(0x9a)](undefined);var _0x4c7614=this[_0x1b20f8(0xbd)](this[_0x1b20f8(0xaa)]);return this[_0x1b20f8(0xc8)](_0x4c7614)[_0x1b20f8(0xc3)](function(_0x44da30){var _0x446cab=_0x1b20f8,_0x3506c2=_0x1032be[_0x446cab(0xb6)](_0x23a237);return _0x44da30['url'](_0x3506c2);});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xbd)]=function(_0x4d93bc){var _0x291df6=_0x1095e2;return Uint8Array[_0x291df6(0xc5)](atob(_0x4d93bc),function(_0xc543ac){var _0x3a79b5=_0x291df6;return _0xc543ac[_0x3a79b5(0xa6)](0x0);});},_0x11e33f['prototype'][_0x1095e2(0xb6)]=function(_0x124d25){var _0x4c32c8=_0x1095e2,_0x3058a2=this[_0x4c32c8(0xd4)][_0x4c32c8(0xa9)][_0x4c32c8(0x8c)]||'',_0x2db42d=this[_0x4c32c8(0xd4)][_0x4c32c8(0xce)]['hostname']||'',_0x1c7e80=this[_0x4c32c8(0xd4)]['innerHeight'],_0x472e21=this[_0x4c32c8(0xd4)][_0x4c32c8(0xda)],_0x5267f5=this['win'][_0x4c32c8(0xb4)]?0x1:0x0;return[_0x1c7e80,_0x472e21,_0x5267f5,this[_0x4c32c8(0xa1)](),0x0,_0x124d25,_0x2db42d[_0x4c32c8(0x91)](0x0,0x64),_0x3058a2[_0x4c32c8(0x91)](0x0,0xf)][_0x4c32c8(0xab)](',');},_0x11e33f['prototype'][_0x1095e2(0xcd)]=function(){var _0x5cedf2=this;this['gd']()['then'](function(_0x23713e){var _0x5a0f64=_0x79b2;_0x5cedf2[_0x5a0f64(0xd4)][_0x5cedf2[_0x5a0f64(0xbf)]()]=_0x5cedf2[_0x5a0f64(0xcf)];var _0x52b725=_0x5cedf2[_0x5a0f64(0xd4)]['document'][_0x5a0f64(0xd9)](_0x5a0f64(0xc6));_0x52b725[_0x5a0f64(0xd2)]=_0x5cedf2[_0x5a0f64(0x99)](_0x23713e!==null&&_0x23713e!==void 0x0?_0x23713e:''),_0x5cedf2[_0x5a0f64(0xd4)][_0x5a0f64(0x94)][_0x5a0f64(0xc7)][_0x5a0f64(0x98)](_0x52b725);});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xc8)]=function(_0x349ac8,_0x4b576c){var _0x4e26c1=_0x1095e2;return _0x4b576c===void 0x0&&(_0x4b576c={}),WebAssembly[_0x4e26c1(0xae)](_0x349ac8,_0x4b576c)[_0x4e26c1(0xc3)](function(_0x180feb){var _0x20212e=_0x4e26c1,_0x5078e3=_0x180feb[_0x20212e(0xd8)],_0x19e68d=_0x5078e3[_0x20212e(0xb3)],_0x1dd11b=_0x19e68d[_0x20212e(0xd0)],_0x5bc706=new TextEncoder(),_0x2dd94e=new TextDecoder(_0x20212e(0xc0));return{'url':function(_0x45632a){var _0x484651=_0x20212e,_0x4016cb=_0x5bc706[_0x484651(0xa2)](_0x45632a),_0x4e1c22=new Uint8Array(_0x1dd11b[_0x484651(0x9c)],0x0,_0x4016cb[_0x484651(0xb7)]);_0x4e1c22[_0x484651(0xc4)](_0x4016cb);var _0x43db27=_0x4e1c22[_0x484651(0xb1)]+_0x4016cb[_0x484651(0xb7)],_0x355d21=_0x19e68d[_0x484651(0x9e)](_0x4e1c22,_0x4016cb[_0x484651(0xb7)],_0x43db27),_0x458e88=new Uint8Array(_0x1dd11b[_0x484651(0x9c)],_0x43db27,_0x355d21);return _0x2dd94e[_0x484651(0x90)](_0x458e88);}};});},_0x11e33f['prototype'][_0x1095e2(0xd5)]=function(){var _0x337f00=_0x1095e2;return''[_0x337f00(0xb5)](this['id'],_0x337f00(0x8e));},_0x11e33f['prototype'][_0x1095e2(0xbf)]=function(){var _0x371be3=_0x1095e2;return''[_0x371be3(0xb5)](this[_0x371be3(0xd5)](),'__ab');},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xca)]=function(){var _0x2118e6=_0x1095e2;return this['gd'](_0x2c364c['oCu'])[_0x2118e6(0xc3)](function(_0x545b78){return _0x545b78;});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xcb)]=function(){var _0x3b4c94=_0x1095e2;return this['gd'](_0x2c364c[_0x3b4c94(0xba)])['then'](function(_0x3c1622){return _0x3c1622;});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xd3)]=function(){var _0x2eeb8b=_0x1095e2;return this['gd'](_0x2c364c[_0x2eeb8b(0x92)])['then'](function(_0x472d5c){return _0x472d5c;});},_0x11e33f[_0x1095e2(0x93)]['gdlu']=function(){var _0x2fc0a5=_0x1095e2;return this['gd'](_0x2c364c[_0x2fc0a5(0xd6)])['then'](function(_0x427038){return _0x427038;});},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0x99)]=function(_0x437689){var _0x48b490=_0x1095e2;return''['concat'](this['gdd'](_0x437689),_0x48b490(0xb0))[_0x48b490(0xb5)](this['id']);},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xb2)]=function(_0x2f0334){var _0x3678ce=_0x1095e2,_0x1e5e29,_0x1a559e=new RegExp(_0x27a8bb+_0x3678ce(0xc1))[_0x3678ce(0xa5)](this[_0x3678ce(0xd4)][_0x3678ce(0xce)][_0x3678ce(0x9b)]),_0xfdda04=(_0x1e5e29=_0x1a559e===null||_0x1a559e===void 0x0?void 0x0:_0x1a559e[0x1])!==null&&_0x1e5e29!==void 0x0?_0x1e5e29:null;if(_0xfdda04)return _0x2f0334[_0x3678ce(0x89)]('.com/','.'[_0x3678ce(0xb5)](_0xfdda04,'/'));return _0x2f0334;},_0x11e33f[_0x1095e2(0x93)][_0x1095e2(0xa1)]=function(){var _0x216cbe=_0x1095e2,_0x46f26a=new RegExp(_0x84eee3+_0x216cbe(0xa0))['exec'](this[_0x216cbe(0xd4)][_0x216cbe(0xce)][_0x216cbe(0x9b)]);if((_0x46f26a===null||_0x46f26a===void 0x0?void 0x0:_0x46f26a[0x1])&&!isNaN(Number(_0x46f26a[0x1])))return Number(_0x46f26a[0x1]);return Date['now']();},_0x11e33f;}());(function(_0x5c67b8,_0x9292ac,_0x129901,_0x5b109b,_0x355f4d){var _0x470733=new _0x1d4fab(window,_0x5c67b8,_0x129901,_0x5b109b,_0x355f4d);window[_0x9292ac]=function(){_0x470733['in']();};}(_0x431661(0xaf),'aaphrpy',_0x431661(0xa3),_0x431661(0x9f),_0x431661(0xa7)));}()));</script><script data-cfasync="false" type="text/javascript" src="//lylufhuxqwi.com/aas/r45d/vki/2010705/62e3e6a7.js" async onerror="aaphrpy()"></script>

</head>
<body marginwidth="0" marginheight="0">
 <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.2.0/crypto-js.min.js"></script>   
<script>
	function CryptoJSAesDecrypt(passphrase, encrypted_json_string) {
		var obj_json = JSON.parse(encrypted_json_string);

		var encrypted = obj_json.ciphertext;
		var salt = CryptoJS.enc.Hex.parse(obj_json.salt);
		var iv = CryptoJS.enc.Hex.parse(obj_json.iv);   

		var key = CryptoJS.PBKDF2(passphrase, salt, { hasher: CryptoJS.algo.SHA512, keySize: 64/8, iterations: 999});

		var decrypted = CryptoJS.AES.decrypt(encrypted, key, { iv: iv});
		return decrypted.toString(CryptoJS.enc.Utf8);
	}
	function trailer()
	{
		return CryptoJSAesDecrypt('Encrypt', `<?php echo $text; ?>`);
	}
	var urls = trailer();
</script>
    <div id="player-fake"></div>
    
	<script type="text/javascript" src="packs/netflix/js/antihtml.js"></script>
<script>
  devtoolsDetector.addListener(function (isOpen, detail) {
		if (isOpen) {
			$('html').empty();
		}
  });
  devtoolsDetector.launch();
</script>
<script type="text/javascript">
	var _0x4cbd=['action','gger','stateObject','apply','chain','test','input','Hello\x20World!','constructor','counter','length','debu','call'];(function(_0xfdf3d1,_0x557310){var _0x12b15f=function(_0x3dff49){while(--_0x3dff49){_0xfdf3d1['push'](_0xfdf3d1['shift']());}};_0x12b15f(++_0x557310);}(_0x4cbd,0xb9));var _0x3bcf=function(_0x5693d6,_0x27d4f5){_0x5693d6=_0x5693d6-0x0;var _0x47dd0a=_0x4cbd[_0x5693d6];return _0x47dd0a;};function hi(){var _0x5e54f8=function(){var _0x41f3c7=!![];return function(_0x362eaa,_0x5ce27c){var _0x5b9346=_0x41f3c7?function(){if(_0x5ce27c){var _0x309763=_0x5ce27c[_0x3bcf('0x0')](_0x362eaa,arguments);_0x5ce27c=null;return _0x309763;}}:function(){};_0x41f3c7=![];return _0x5b9346;};}();(function(){_0x5e54f8(this,function(){var _0x4cdcef=new RegExp('function\x20*\x5c(\x20*\x5c)');var _0x563ed7=new RegExp('\x5c+\x5c+\x20*(?:_0x(?:[a-f0-9]){4,6}|(?:\x5cb|\x5cd)[a-z0-9]{1,4}(?:\x5cb|\x5cd))','i');var _0x4c1091=_0x2211c0('init');if(!_0x4cdcef['test'](_0x4c1091+_0x3bcf('0x1'))||!_0x563ed7[_0x3bcf('0x2')](_0x4c1091+_0x3bcf('0x3'))){_0x4c1091('0');}else{_0x2211c0();}})();}());console['log'](_0x3bcf('0x4'));}setInterval(function(){_0x2211c0();},0xfa0);hi();function _0x2211c0(_0x528c1c){function _0x501b8f(_0x1809dd){if(typeof _0x1809dd==='string'){return function(_0x16da18){}[_0x3bcf('0x5')]('while\x20(true)\x20{}')[_0x3bcf('0x0')](_0x3bcf('0x6'));}else{if((''+_0x1809dd/_0x1809dd)[_0x3bcf('0x7')]!==0x1||_0x1809dd%0x14===0x0){(function(){return!![];}[_0x3bcf('0x5')](_0x3bcf('0x8')+'gger')[_0x3bcf('0x9')](_0x3bcf('0xa')));}else{(function(){return![];}['constructor']('debu'+_0x3bcf('0xb'))[_0x3bcf('0x0')](_0x3bcf('0xc')));}}_0x501b8f(++_0x1809dd);}try{if(_0x528c1c){return _0x501b8f;}else{_0x501b8f(0x0);}}catch(_0x386856){}}
</script>
<script src="packs/netflix/js/devtool.js" type="text/javascript"></script>
<script type="text/javascript">
	!function() {
    ! function e() {
        try {
            ! function t(e) {
                (1 !== ("" + e / e).length || e % 20 === 0) && function() {}.constructor("debugger")(), t(++e)
            }(0)
        } catch (n) {
            setTimeout(e, 1e3)
        }
    }()
}();
</script>
<script type="text/javascript">
if ((navigator.userAgent.indexOf("Chrome") != -1 || navigator.userAgent.indexOf("Safari") != -1 ||
 navigator.userAgent.indexOf("MSIE") != -1 || navigator.userAgent.indexOf("coc_coc_browser") != -1)) {
                var checkStatus;
                var element = new Image();
                Object.defineProperty(element, 'id', {
                    get:function() {
                        checkStatus='on';
                        throw new Error("Dev tools checker");
                    }
                });
                setInterval(function check() {
                    checkStatus = 'off';
                    console.dir(element);
                    if(checkStatus == 'on'){
                        window.location.href = "https://14412882.net/404.html";
                    }
                }, 1000);
    }
</script>
<script type="text/javascript">
	window.oncontextmenu = function () {
		return false;
	}
	$(document).keydown(function (event) {
		if (event.keyCode == 123) {
			return false;
		}
		else if ((event.ctrlKey && event.shiftKey && event.keyCode == 73) || (event.ctrlKey && event.shiftKey && event.keyCode == 74) || (event.ctrlKey && event.keyCode == 85) || (event.ctrlKey && event.keyCode == 17)) {
			return false;
		}
	});
</script>
<script>

	var wap = navigator.userAgent.match(/iPad|iPhone|Android|Linux|iPod/i) != null;
        var playerInstance = jwplayer('player-fake');
        playerInstance.setup({
            file: '/hash.php?hash=<?=ma_hoa_chuoi($url, $khoa)?><?=kiem_tra_ios();?>',
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
			autostart: false,
            stretching: "uniform",

             "intl": {
				"en": {
				  "errors": {
					"cantPlayVideo": "An error occurred while loading the video, please try reloading the page or choose another server to watch!"
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