<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Info extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
        //Judgment login
		$this->user->login();
        //Current template
		$this->load->get_templates();
	}

	//Modify data
	public function edit(){
		$data['title'] = 'Modify data - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;
        $this->load->view('head.tpl',$data);
        $this->load->view('info_edit.tpl');
        $this->load->view('bottom.tpl');
	}

	//Change Password
	public function pass(){
		$data['title'] = 'Change Password - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;
        $this->load->view('head.tpl',$data);
        $this->load->view('info_pass.tpl');
        $this->load->view('bottom.tpl');
	}

	//Help document
	public function docs(){
		$data['title'] = 'Documents - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;
        $this->load->view('head.tpl',$data);
        $this->load->view('info_docs.tpl');
        $this->load->view('bottom.tpl');
	}

	//Login log
	public function log(){
		$data['title'] = 'Login log - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;

		$page = (int)$this->input->get('page');
		if($page == 0) $page = 1;
		$where = array();
		$where['uid'] = $user->id;
		//Quantity per page
		$per_page = 15;
		$total = $this->csdb->get_nums('user_log',$where);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));
		//Data
        $data['log'] = $this->csdb->get_select('user_log','*',$where,'addtime DESC',$limit);
        $data['pages'] = get_page($total,$pagejs,$page,'info','log');

        $this->load->view('head.tpl',$data);
        $this->load->view('info_log.tpl');
        $this->load->view('bottom.tpl');
	}

	//Add, modify storage
	public function save($op='edit'){

		if($op == 'pass'){
			$pass1 = $this->input->post('pass1',true);
			$pass2 = $this->input->post('pass2',true);
			$pass3 = $this->input->post('pass3',true);
			if(empty($pass1) || empty($pass2)) getjson('Incomplete data');
			if($pass2 != $pass3) getjson('The two passwords do not match');
			$ypass = getzd('user','pass',$this->cookie->get('user_id'));
			if($ypass != md5($pass1)) getjson('The original password is incorrect');
			$edit['pass'] = md5($pass3);
		}else{
			$edit['email'] = $this->input->post('email',true);
			$edit['telegram'] = $this->input->post('telegram',true);
			$edit['url'] = $this->input->post('url',true);
			if(empty($edit['email']) || empty($edit['url']) || empty($edit['telegram'])) getjson('Incomplete data');
		}
		if(isset($edit['telegram'])) {
		if (!preg_match('/^@[\w]+$/', $edit['telegram'])) {
        getjson('Please enter a valid Telegram username (e.g., @username)');
    }
}
		$this->db->update("user",$edit,array('id'=>$this->cookie->get('user_id')));
		getjson(array('msg'=>'Modified and updated successfully','url'=>links('info',$op)),1);
	}
}