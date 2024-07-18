<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Login extends CI_Controller {
	function __construct(){
	    parent::__construct();
        //Current template
		$this->load->get_templates();
	}

	public function index(){
		$data['link'] = $this->csdb->get_select('link','*',array(),'id DESC',100);
        $this->load->view('login.tpl',$data);
	}

	public function save(){
        $name = $this->input->post('name',true);
        $pass = $this->input->post('pass',true);
        $code = $this->input->post('code',true);
        if(empty($name) || empty($pass) || empty($code)){
        	getjson('Incomplete information');
        }
        if($this->cookie->get('codes') != strtolower($code)){
        	getjson('Incorrect verification code');
        }
        $row = $this->csdb->get_row('user','*',array('name'=>$name));
        if(!$row) getjson('Member does not exist');
        if($row->pass != md5($pass)) getjson('Incorrect password');
		if($row->zt > 0) getjson('The account has not been reviewed, please contact the webmaster for review');
        //Write login record
        $this->load->library('user_agent');
        $agent = ($this->agent->is_mobile() ? $this->agent->mobile() : $this->agent->platform()).'&nbsp;/&nbsp;'.$this->agent->browser().' v'.$this->agent->version();
        $add['uid'] = $row->id;
        $add['ip'] = getip();
        $add['addtime'] = time();
        $add['info'] = $agent;
        $this->csdb->get_insert('user_log',$add);

        if (empty($row->apikey)) {
            $this->csdb->get_update('user',$row->id,array('apikey'=> $this->generateRandomString(29)));
        }
        
        //Success
        $time = time()+86400*15;
        $this->cookie->set('user_id',$row->id,$time);
        $this->cookie->set('user_login',md5($row->id.$row->name.$row->pass),$time);
        $this->cookie->set('codes');
        getjson(array('msg'=>'Login successful, please wait...','url'=>links('vod')),1);
	}

    //Quit
    public function ext(){
        //Write to cookies
        $this->cookie->set('user_id');
        $this->cookie->set('user_login');
        header("location:".links('login'));
        exit;
    }

    private function generateRandomString($length = 10) {
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }
}