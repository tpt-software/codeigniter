<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Login extends CI_Controller {

	public function __construct(){
		parent::__construct();
        //Current template
		$this->load->get_templates();
	}

	//Admin login
    public function index() {
		$data['title'] = 'Admin login - '.Web_Name;
        $this->load->view('login.tpl',$data);
	}

	//Login
	public function save(){
		$adminname = $this->input->get_post('adminname',true);
		$adminpass = $this->input->get_post('adminpass',true);
		if(empty($adminname) || empty($adminpass)){
			getjson('Account password cannot be left blank');
		}
		$row = $this->csdb->get_row('admin','*',array('name'=>$adminname));
		if(!$row){
			getjson('Account number is incorrect');
		}
		if(md5($adminpass) != $row->pass){
			getjson('Incorrect password');
		}
		//Update login information
		$this->csdb->get_update('admin',$row->id,array('logip'=>getip(),'logtime'=>time()));
        //Write to cookies
        $cookietime = time()+86400*30;
        $this->cookie->set('admin_id',$row->id,$cookietime);
        $this->cookie->set('admin_nichen',$row->nichen,$cookietime);
        $this->cookie->set('admin_logip',$row->logip,$cookietime);
        $this->cookie->set('admin_logtime',$row->logtime,$cookietime);
        $this->cookie->set('admin_login',md5($row->id.$row->name.$row->pass),$cookietime);
        $info['url'] = links('index');
		$info['msg'] = 'Login successful';
        getjson($info,1);
	}

	//Quit
	public function ext(){
        //Write to cookies
        $this->cookie->set('admin_id');
        $this->cookie->set('admin_nichen');
        $this->cookie->set('admin_logip');
        $this->cookie->set('admin_logtime');
        $this->cookie->set('admin_login');
        header("location:".links('login'));exit;
	}
}

