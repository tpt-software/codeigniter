<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Forgot extends CI_Controller {
	function __construct(){
	    parent::__construct();

        //Current template
		$this->load->get_templates();
	}

	public function index(){
        $this->load->view('forgot.tpl');
	}

	public function save(){
        $email = $this->input->post('email',true);
        $code = $this->input->post('code',true);
        if(empty($email) || empty($code)){
        	getjson('Incomplete information');
        }
        if($this->cookie->get('codes') != strtolower($code)){
        	getjson('Incorrect verification code');
        }
       
        $row = $this->csdb->get_row('user','id',array('email' => $email));
        if(empty($row)) getjson('Email is not existed');


        $newPassword = $this->_randomPassword();
        $data = array(
            'pass' => md5($newPassword),
            'addtime' => time()
        );
        $this->csdb->get_update("user", array('id' => $row->id), $data);

        // send email
        $this->load->library('email');

        $this->email->from('admin@helvid.com', 'Helvid.com');
        $this->email->to($email);
        $this->email->subject('Reset password');
        $this->email->message(sprintf('Your new password: %s', $newPassword));
        $this->email->send();    

        //Write login record
        $this->load->library('user_agent');
        $agent = ($this->agent->is_mobile() ? $this->agent->mobile() : $this->agent->platform()).'&nbsp;/&nbsp;'.$this->agent->browser().' v'.$this->agent->version();
        $add2['uid'] = $res;
        $add2['ip'] = getip();
        $add2['addtime'] = time();
        $add2['info'] = $agent;
        $this->csdb->get_insert('user_log', $add2);


        getjson(array('msg'=>'New password sent to email successfully. Please check your email', 'url' => links('login')),1);
	}

    private function _randomPassword() {
        $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
        $pass = array(); //remember to declare $pass as an array
        $alphaLength = strlen($alphabet) - 1; //put the length -1 in cache
        for ($i = 0; $i < 8; $i++) {
            $n = rand(0, $alphaLength);
            $pass[] = $alphabet[$n];
        }
        return implode($pass); //turn the array into a string
    }
}