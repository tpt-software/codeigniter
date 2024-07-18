<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Pay extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
        //Judgment login
		$this->user->login();
        //Current template
		$this->load->get_templates();
	}

    public function index(){
		$data['title'] = 'Modify data - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;
        $this->load->view('head.tpl',$data);
        $this->load->view('pay.tpl');
        $this->load->view('bottom.tpl');
	}
}
