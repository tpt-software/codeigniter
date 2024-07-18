<?php
/**
 * @14412882 open source management system
 * @copyright 2016-2017 14412882.com. All rights reserved.
 * @Author:Chi Tu
 * @Dtime:2016-08-11
 */

//Get any field information
function getzd($table,$ziduan,$id,$cha='id'){
	$ci = &get_instance();
	if (!isset($ci->db)){
		$ci->load->database();
	}
	$ziduans= ($ziduan=='nichen') ? 'name,nichen' : $ziduan;
	if($table && $ziduan && $id){
		$ci->db->where($cha,$id);
		$ci->db->select($ziduans);
		$row=$ci->db->get($table)->row();
		if($row){
			$str=$row->$ziduan;
			if($ziduan=='nichen' && empty($str)) $str=$row->name;
		}else{
			$str="";	
		}
		if($ziduan=='pic'){
			$str=getpic($str);
		}
		return $str;
	}
}
//Parse multiple category IDs such as cid=1,2,3,4,5,6
function getcid($CID,$type='myclass',$zd='fid'){
	$ci = &get_instance();
	if (!isset($ci->db)){
		$ci->load->database();
	}
	if(!empty($CID)){
		$ClassArr=explode(',',$CID);
		for($i=0;$i<count($ClassArr);$i++){
			$sql="select id from ".CT_SqlPrefix.$type." where ".$zd."='$ClassArr[$i]'";//The organization of the sql statement returns
			$result=$ci->db->query($sql)->result();
			if(!empty($result)){
				   foreach ($result as $row) {
						$ClassArr[]=$row->id;
				   }
			}
			$CID=implode(',',$ClassArr);
		}
	}
	return $CID;
}
//Function to intercept a string
function sub_str($str, $length, $start=0, $suffix="...", $charset="utf-8"){
	$str=str_checkhtml($str);
	if(($length+2) >= strlen($str)){
		return $str;
	}
	if(function_exists("mb_substr")){
		return mb_substr($str, $start, $length, $charset).$suffix;
	}elseif(function_exists('iconv_substr')){
		return iconv_substr($str,$start,$length,$charset).$suffix;
	}
	$re['utf-8']  = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xff][\x80-\xbf]{3}/";
	$re['gb2312'] = "/[\x01-\x7f]|[\xb0-\xf7][\xa0-\xfe]/";
	$re['gbk']    = "/[\x01-\x7f]|[\x81-\xfe][\x40-\xfe]/";
	$re['big5']   = "/[\x01-\x7f]|[\x81-\xfe]([\x40-\x7e]|\xa1-\xfe])/";
	preg_match_all($re[$charset], $str, $match);
	$slice = join("",array_slice($match[0], $start, $length));
	return $slice.$suffix;
}
//Write file
function write_file($path, $data, $mode = FOPEN_WRITE_CREATE_DESTRUCTIVE){
	$dir = dirname($path);
	if(!is_dir($dir)){
		mkdirss($dir);
	}
	if ( ! $fp = @fopen($path, $mode))
	{
		return FALSE;
	}
	flock($fp, LOCK_EX);
	fwrite($fp, $data);
	flock($fp, LOCK_UN);
	fclose($fp);
	return TRUE;
}
//Create folders recursively
function mkdirss($dir) {
    if (!$dir) {
        return FALSE;
    }
    if (!is_dir($dir)) {
        mkdirss(dirname($dir));
        if (!file_exists($dir)) {
            mkdir($dir, 0777);
        }
    }
    return true;
}
//Remove all spaces
function trimall($str){
    $qian=array(" ","　","\t","\n","\r");$hou=array("","","","","");
    return str_replace($qian,$hou,$str);    
}
//HTML to character
function str_encode($str){
	if(is_array($str)) {
		foreach($str as $k => $v) {
			$str[$k] = str_encode($v); 
		}
	}else{
		$str=str_replace("<","&lt;",$str);
		$str=str_replace(">","&gt;",$str);
		$str=str_replace("\"","&quot;",$str);
		$str=str_replace("'",'&#039;',$str);
	}
	return $str;
}
//Character to HTML
function str_decode($str){
	if(is_array($str)) {
		foreach($str as $k => $v) {
			$str[$k] = str_decode($v); 
		}
	}else{
		$str=str_replace("&lt;","<",$str);
		$str=str_replace("&gt;",">",$str);
		$str=str_replace("&quot;","\"",$str);
		$str=str_replace("&#039;","'",$str);
	}
	return $str;
}
//SQL filtering
function safe_replace($string){
	if(is_array($string)) {
		foreach($string as $k => $v) {
			$string[$k] = safe_replace($v); 
		}
	}else{
		if(!is_numeric($string)){
			$string = str_replace('%20','',$string);
			$string = str_replace('%27','',$string);
			$string = str_replace('%2527','',$string);
			$string = str_replace("'",'&#039;',$string);
			$string = str_replace('"','&quot;',$string);
			$string = str_replace(';','',$string);
			$string = str_replace('*','',$string);
			$string = str_replace('<','&lt;',$string);
			$string = str_replace('>','&gt;',$string);
			$string = str_replace('\\','',$string);
			$string = str_replace('%','\%',$string);
			$string = str_encode($string);
		}
	}
	return $string;
}
//Block all html
function str_checkhtml($str,$sql=0) {
	if(is_array($str)) {
		foreach($str as $k => $v) {
			$str[$k] = str_checkhtml($v); 
		}
	}else{
		$str = preg_replace("/\s+/"," ", $str);
		$str = preg_replace("/&nbsp;/","",$str);
		$str = preg_replace("/\r\n/","",$str);
		$str = preg_replace("/\n/","",$str);
		$str = str_replace(chr(13),"",$str);
		$str = str_replace(chr(10),"",$str);
		$str = str_replace(chr(9),"",$str);
		$str = strip_tags($str);
		$str = str_encode($str);
	}
	if($sql==1){
		$str = safe_replace($str);
	}
	return $str;
}
//Get ip
function getip(){ 
	$ci = &get_instance();
	$ip = $ci->input->ip_address();
	if(preg_match("/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/",$ip)){
		return $ip; 
	}else{
		return "";
	}
}
//Get remote content
function geturl($url,$post=''){
	// fopen mode
	if(function_exists('curl_init')){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
		curl_setopt($ch, CURLOPT_AUTOREFERER, 1);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
		curl_setopt($ch, CURLOPT_TIMEOUT, 10);
		curl_setopt($ch, CURLOPT_HEADER, 0);
		//curl_setopt($ch, CURLOPT_ENCODING, "gzip");
		if(!empty($post)){
			curl_setopt($ch, CURLOPT_POST, 1);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
		}
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);//After getting the jump
		$data = curl_exec($ch);
		curl_close($ch);
	}
	return $data;
}
//Character encryption, decryption
function sys_auth($string, $type = 0, $key = '', $expiry = 0) { 
	if($type == 1) $string = str_replace('-','+',$string);
	$ckey_length = 4;  
	$key = md5($key ? $key : CT_Encryption_Key);   
	$keya = md5(substr($key, 0, 16));     
	$keyb = md5(substr($key, 16, 16));     
	$keyc = $ckey_length ? ($type == 1 ? substr($string, 0, $ckey_length): substr(md5(microtime()), -$ckey_length)) : ''; 
	$cryptkey = $keya.md5($keya.$keyc);   
	$key_length = strlen($cryptkey);     
	$string = $type == 1 ? base64_decode(substr($string, $ckey_length)) :  sprintf('%010d', $expiry ? $expiry + time() : 0).substr(md5($string.$keyb), 0, 16).$string;   
	$string_length = strlen($string);   
	$result = '';   
	$box = range(0, 255);   
	$rndkey = array();     
	for($i = 0; $i <= 255; $i++) {   
		$rndkey[$i] = ord($cryptkey[$i % $key_length]);   
	}     
	for($j = $i = 0; $i < 256; $i++) {   
		$j = ($j + $box[$i] + $rndkey[$i]) % 256;   
		$tmp = $box[$i];   
		$box[$i] = $box[$j];   
		$box[$j] = $tmp;   
	}   
	for($a = $j = $i = 0; $i < $string_length; $i++) {   
		$a = ($a + 1) % 256;   
		$j = ($j + $box[$a]) % 256;   
		$tmp = $box[$a];   
		$box[$a] = $box[$j];   
		$box[$j] = $tmp;   
		$result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));   
	}   
	if($type == 1) {    
		if((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26).$keyb), 0, 16)) {   
			return substr($result, 26);   
		} else {   
			return '';   
		}   
	} else {    
		return str_replace('+', '-', $keyc.str_replace('=', '', base64_encode($result)));   
	}
}
//Json output
function getjson($arr,$code=0,$callback='') {
	if(!is_array($arr)){
		$data['msg'] = $arr;
	}else{
		$data = $arr;
	}
	$data['code'] = $code;
	$json = json_encode($data);
	if(!empty($callback)){
		echo $callback."(".$json.")";
	}else{
		echo $json;
	}
	exit;
}

function formatsize($size, $dec=2){
	$a = array("B", "KB", "MB", "GB", "TB", "PB");
	$pos = 0;
	while ($size >= 1024) {
		$size /= 1024;
		$pos++;
	}
	return round($size,$dec)." ".$a[$pos];
}

function formattime($time,$sign=0){
	$h = $m = $s = 0;
	$str = '';
	$s = floor($time%60);
	$m = floor($time/60)%60;
	$h = floor($time/60/60);
	if($sign==0){
		if($h>0)  return $str = $h."hour".$m."minute".$s.'second';
		if($m>0)  return $str = $m."minute".$s.'second';
		return $str = $s.'second';
	}
	if($sign==1){
		if($m<10) $m = '0'.$m;
		if($s<10) $s = '0'.$s;
		if($h>0)  return $str = $h.":".$m.":".$s;
		if($m>0)  return $str = $m.":".$s;
		return $str = '00:'.$s;
	}
}
//Delete directories and files
function deldir($dir,$sid=1) {
	if(!is_dir($dir)){
		return true;
	}
	//Delete the files in the directory first
	$dh=opendir($dir);
	while ($file=readdir($dh)) {
		if($file!="." && $file!="..") {
			$fullpath=$dir."/".$file;
			if(!is_dir($fullpath)) {
				@unlink($fullpath);
			} else {
				deldir($fullpath,$sid);
			}
		}
	}
	closedir($dh);
	//Delete current folder
	if($sid==1){
		if(@rmdir($dir)) {
			return true;
		} else {
			return false;
		}
	}else{
		return true;
	}
}
//Get M3U8 address
function m3u8_link($vid,$time,$ac='m3u8',$num=1,$server=array()){
	$zmdir = isset($server['m3u8dir']) ? $server['m3u8dir'] : '';
	$host = isset($server['cdnurl']) ? $server['cdnurl'] : '';
	if($ac == 'm3u8'){
		$dirfile = m3u8_dir($vid,$time,$zmdir).'playlist.m3u8';
		$host2 = Web_M3u8_Url != '' ? Web_M3u8_Url : Web_Url;
	}else{
		$dirfile = m3u8_dir($vid,$time,$zmdir).$num.'.jpg';
		$host2 = Web_Pic_Url != '' ? Web_Pic_Url : Web_Url;
	}
	if(substr($dirfile,0,2) == './'){
		$dirfile = substr($dirfile,1);
	}else{
		$dirfile = str_replace($zmdir, '/', $dirfile);
	}
	if(empty($host)){
		$link = 'http://'.$host2.$dirfile;
	}else{
		if(substr($zmdir,0,2) == './') $zmdir = substr($zmdir,1);
		if(substr($host,-1) == '/' && substr($dirfile,0,1) == '/') $dirfile = substr($dirfile,1);
		if(strpos($host, $zmdir) !== false){
			$link = str_replace($zmdir, '/', $host).$dirfile;
		}else{
			$link = $host.$dirfile;
		}
	}
	return $link;
}
//Get slice file directory
function m3u8_dir($vid,$time,$zmdir = ''){
	if(empty($zmdir)) $zmdir = Zm_Dir;
	$dir = $zmdir.date('Ym',$time).'/'.$vid.'/';
	return $dir;
}
//Generate short ID
function get_vid($id) {
	$md5 = md5($id.time());
    return substr($md5,10,-10);
}
//Time format conversion
function get_time($time = NULL) {
    $text = '';
    $time = $time === NULL || $time > time() ? time() : intval($time);
    $t = time() - $time; //time difference (seconds)
    $y = date('Y', $time)-date('Y', time());//New Year's Eve
    switch($t){
     case $t == 0:
       $text = 'only';
       break;
     case $t < 60:
      $text = $t . ' seconds ago'; // Within a minute
      break;
     case $t < 60 * 60:
      $text = floor($t / 60) . ' minutes ago'; //Within an hour
      break;
     case $t < 60 * 60 * 24:
      $text = floor($t / (60 * 60)) . ' hour ago'; // in one day
      break;
     case $t < 60 * 60 * 24 * 3:
      $text = floor($time/(60*60*24)) ==1 ?' yesterday ' . date('H:i', $time) : ' the day before yesterday ' . date('H:i', $time) ; //Yesterday and the day before yesterday
      break;
     case $t < 60 * 60 * 24 * 30:
      $text = sprintf("%01.0f",$t/86400).' days ago'; //Within a month
      break;
     case $t < 60 * 60 * 24 * 365 && $y==0:
      $text = sprintf("%01.0f",$t/2592000).' month ago'; //Within a year
      break;
     default:
      $text = date('Y year m month d day', $time); //A year ago
      break;
    }
    return $text;
}
//Record transcoding log
function get_log($txt){
	$logpath = FCPATH.'caches/ting/'.date('Y-m').'/';
	mkdirss($logpath);
	$logpath .= date('d').'.log';
	$log = '';
	if(file_exists($logpath)){
		$log = file_get_contents($logpath);
	}
	$log .= "\r\n".$txt;
	write_file($logpath,$log);
}