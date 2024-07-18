<?php
/**
 * @14412882 open source management system
 * @copyright 2016-2017 14412882.com. All rights reserved.
 * @Author:Chi Tu
 * @Dtime:2016-08-08
 */
if (!defined('BASEPATH')) exit('No direct script access allowed');
class Admin extends CI_Model
{
    function __construct (){
	   parent:: __construct ();
    }
    //Determine whether to log in
    function login($sid=0,$key=''){
		  $session = 1;
		  if(empty($key)){
              $id = (int)$this->cookie->get('admin_id');
              $login =  $this->cookie->get('admin_login');
		  }else{
			  $str  = unserialize(stripslashes(sys_auth($key,'D')));
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
          $admin=$this->csdb->get_row('admin','id,name,pass',array('id'=>$id));
		  if($admin){
                if(md5($admin->id.$admin->name.$admin->pass)!=$login){
                	$this->cookie->set('admin_id');
                	$this->cookie->set('admin_login');
					if($sid==0){
						header("location:".links('login'));exit;
					}else{
						return 0;
					}
                }
          }else{
			    $this->cookie->set('admin_id');
                $this->cookie->set('admin_login');
				if($sid==0){
                    header("location:".links('login'));exit;
				}else{
					return 0;
				}
          }
		  if($sid==1) return 1;
    }
}