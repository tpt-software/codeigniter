<?php
/**
 * @14412882 open source management system
 * @copyright 2016-2017 14412882.com. All rights reserved.
 * @Author:Chi Tu
 * @Dtime:2016-08-08
 */
if (!defined('BASEPATH')) exit('No direct script access allowed');
class User extends CI_Model{
    function __construct (){
	   parent:: __construct ();
    }

    //Determine whether to log in
    function login($sid=0,$key=''){
        if(empty($key)){
            $id = (int)$this->cookie->get('user_id');
            $login =  $this->cookie->get('user_login');
        }else{
            $str  = json_decode(sys_auth($key,1),1);
            $id   = isset($str['id'])?intval($str['id']):0;
            $login = isset($str['login'])?$str['login']:'';
        }
        if(empty($id) || empty($login)){
            if($sid==0){
                header("location:".links('login'));exit;
        	}else{
                return 0;
        	} 
        }
        $user=$this->csdb->get_row('user','id,name,pass',array('id'=>$id));
        if($user){
            if(md5($user->id.$user->name.$user->pass) != $login){
            	$this->cookie->set('user_id');
            	$this->cookie->set('user_login');
        		if($sid==0){
        			header("location:".links('login'));exit;
        		}else{
        			return 0;
        		}
            }
        }else{
            $this->cookie->set('user_id');
            $this->cookie->set('user_login');
        	if($sid==0){
                header("location:".links('login'));exit;
        	}else{
        		return 0;
        	}
        }
        if($sid==1) return 1;
    }
}