<?php
if (!defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Cookie class
 */
class Cookie {
	function __construct()
	{
		log_message('debug', "Native Session Class Initialized");
	}
	//Set cookies
	public static function set($var, $value = '', $time = 0) {
		$time = $time > 0 ? $time : ($value == '' ? time() - 3600 : 0);
		$s = $_SERVER['SERVER_PORT'] == '443' ? 1 : 0;
		$var = CT_Cookie_Prefix.$var;
        $ips=explode(':',$_SERVER['HTTP_HOST']);
		$Domain = CT_Cookie_Domain;
		setcookie($var,sys_auth($value,0,$var.CT_Encryption_Key),$time, Web_Path, $Domain, $s);
	}
    //Get cookie
    public static function get($var, $default = '') {
		$var = CT_Cookie_Prefix.$var;
		$value = isset($_COOKIE[$var]) ? sys_auth($_COOKIE[$var],1,$var.CT_Encryption_Key) : $default;
		$value = safe_replace($value);
		return $value;
	}
}