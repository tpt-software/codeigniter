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

        // login if has remmeber token
        if (!empty($_COOKIE['remember_me'])) {
            
            $remember_token = $_COOKIE['remember_me'];
            $row = $this->csdb->get_row('user','*',array('remember_token'=>$remember_token));
            if ($row && $row->remember_token == $remember_token) {

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

                header("location:".links('vod'));

            } else {
                setcookie('remember_me', '', time() - 3600, '/');
            }
        }
        
        $this->load->view('login.tpl',$data);
	}

	public function save(){
        $name = $this->input->post('name',true);
        $pass = $this->input->post('pass',true);
        $otp = $this->input->post('otp',true);
        $remember = $this->input->post('remember_me',true);
        
        if(empty($name) || empty($pass)){
        	getjson('Incomplete information');
        }

        // Handle secure code (old version)
        // if($this->cookie->get('codes') != strtolower($code)){
        // 	getjson('Incorrect verification code');
        // }

        $row = $this->csdb->get_row('user','*',array('name'=>$name));
        if($row->pass != md5($pass)) getjson('Incorrect password');
		if($row->zt > 0) getjson('The account has not been reviewed, please contact the webmaster for review');
        
        if(empty($otp)){
            //Send otp after login
            if ($row->email) {
                // create otp
                $otp = str_pad(random_int(100000, 999999), 6, '0', STR_PAD_LEFT);
                
                // save otp
                $data = array(
                    'otp' => $otp,
                );
                $this->csdb->get_update("user", array('id' => $row->id), $data);

                // send email
                $this->load->library('email');
        
                $this->email->from($this->email->smtp_user, 'Admin');
                $this->email->to($row->email);
                $this->email->subject('OTP');
                $this->email->message(sprintf('Your OTP : %s', $otp));
                $this->email->send();    

                getjson('OTP has sent. Please check email',2);
            }else{

                getjson('Does not exist email. Please update email!');
            }
        }else{
            // check otp
            $row = $this->csdb->get_row('user','*',array('name'=>$name));

            // return mess if incorrect
            if ($row->otp !== $otp) {

                getjson('Incorrect OTP');
            }else{

                // delete otp after confirm
                $data = array(
                    'otp' => '',
                );
                $this->csdb->get_update("user", array('id' => $row->id), $data);
            }
        }
        if($remember){
            $remember_token = bin2hex(random_bytes(50));
            $data = array(
                'remember_token' => $remember_token,
            );
            $this->csdb->get_update("user", $row->id, $data);
            setcookie('remember_me', $remember_token, time() + (86400 * 30), '/');
        }
        
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
        if (isset($_COOKIE['remember_me'])) {
            $remember_token = $_COOKIE['remember_me'];
            $row = $this->csdb->get_row('user','remember_token',array('remember_token'=>$remember_token));
            setcookie('remember_me', '', time() - 3600, '/');
        }
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