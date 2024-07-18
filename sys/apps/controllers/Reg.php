<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Reg extends CI_Controller {
	function __construct(){
	    parent::__construct();
        //Current template
		$this->load->get_templates();
	}

	public function index(){
        $this->load->view('reg.tpl');
	}

	public function save(){
                $name = $this->input->post('name',true);
                $pass = $this->input->post('pass',true);
                $repass = $this->input->post('repass',true);
                $email = $this->input->post('email',true);
        //        $code = $this->input->post('code',true);
        //        if(empty($name) || empty($pass) || empty($email) || empty($code)){
        //        	getjson('Incomplete information');
        //        }
        //        if($this->cookie->get('codes') != strtolower($code)){
        //        	getjson('Incorrect verification code');
        //        }
                if($pass != $repass){
                        getjson('The two passwords do not match');
                }
                $row = $this->csdb->get_row('user','id',array('name'=>$name));
                if($row) getjson('Account has been registered');
                $row = $this->csdb->get_row('user','id',array('email'=>$email));
                if($row) getjson('Email is registered');
                //Storage
                $add['name'] = $name;
                $add['pass'] = md5($pass);
                $add['email'] = $email;
                $add['apikey'] = $this->generateRandomString(29);
                $add['zt'] = Web_Reg;
                $add['addtime'] = time();
                $res = $this->csdb->get_insert('user',$add);
                if(!$res) getjson('Registration failed, try again later');
                //Write login record
                $this->load->library('user_agent');
                $agent = ($this->agent->is_mobile() ? $this->agent->mobile() : $this->agent->platform()).'&nbsp;/&nbsp;'.$this->agent->browser().' v'.$this->agent->version();
                $add2['uid'] = $res;
                $add2['ip'] = getip();
                $add2['addtime'] = time();
                $add2['info'] = $agent;
                $this->csdb->get_insert('user_log',$add2);

                        //No review
                if(Web_Reg == 0){
                        //Success
                        $time = time()+86400*15;
                        $this->cookie->set('user_id',$res,$time);
                        $this->cookie->set('user_login',md5($res.$name.md5($pass)),$time);
                        $this->cookie->set('codes');
                        getjson(array('msg'=>'Registration successful, please wait...','url'=>links('vod')),1);
                }else{
                        getjson(array('msg'=>'Registration is successful, please wait for the webmaster to review','url'=>links('login')),1);
                }
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