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

        public function success(){
                $this->load->view('confirm.tpl');
        }

	public function save(){
                $name = $this->input->post('name',true);
                $pass = $this->input->post('pass',true);
                $repass = $this->input->post('repass',true);
                $email = $this->input->post('email',true);
                $is_notification = $this->input->post('is_notification',true);

                // $code = $this->input->post('code',true);
                // if(empty($name) || empty($pass) || empty($email) || empty($code)){
                // 	getjson('Incomplete information');
                // }
                // if($this->cookie->get('codes') != strtolower($code)){
                // 	getjson('Incorrect verification code');
                // }
                if($pass != $repass){
                        getjson('The two passwords do not match');
                }

                $row = $this->csdb->get_row('user','id',array('name'=>$name));
                if($row) getjson('Account has been registered');
                $row = $this->csdb->get_row('user','id',array('email'=>$email));
                if($row) getjson('Email is registered');
                
                //Storage
                $token = $this->generateRandomString(16);
                $add['name'] = $name;
                $add['pass'] = md5($pass);
                $add['email'] = $email;
                $add['apikey'] = $this->generateRandomString(29);
                $add['zt'] = Web_Reg;
                $add['addtime'] = time();
                $add['token'] = $token;
                $add['is_notification'] = $is_notification ? 1 : 0;
                $res = $this->csdb->get_insert('user',$add);
                
                if(!$res) getjson('Registration failed, try again later');
                
                //No review
                if(Web_Reg == 0){
                        // Send email verify
                        $this->load->library('email');
                        $this->email->from('admin@helvid.com', 'Helvid.com');
                        $this->email->to($email);
                        $this->email->subject('Confirm email');
                        $this->email->message(sprintf('Please click the following link to verify your account:
                                <a href="%s/reg/confirm?token=%s">%s/reg/confirm?token=%s</a>', $_SERVER['HTTP_HOST'], $token, $_SERVER['HTTP_HOST'], $token));
                        $this->email->send(); 
                        getjson(array('msg'=>'We sent email for you, Please confirm before login','url'=>links('login')),1);
                        
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

        public function confirm(){
                $token = $_GET['token'];
                if (strlen($token) !== 16) {
                        header("location:".links('404'));
                }
                $row = $this->csdb->get_row('user','*',array('token'=>$token));
                $this->csdb->get_update('user',$row->id,array('is_verify'=> 1));
                if (!empty($row)) {
                        
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

                        //login
                        $time = time()+86400*15;
                        $this->cookie->set('user_id',$row->id,$time);
                        $this->cookie->set('user_login',md5($row->id.$row->name.$row->pass),$time);
                        $this->cookie->set('codes');

                        $this->csdb->get_update('user',$row->id,array('token'=> ''));
                        $this->csdb->get_update('user',$row->id,array('is_verify'=> 1));
                        
                        $this->load->view('confirm.tpl');
                }else{
                        header("location:".links('login'));
                }
        }
}