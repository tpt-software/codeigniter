<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Fav extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
        //Judgment login
		$this->user->login();
        //Current template
		$this->load->get_templates();
	}

	//My video
	public function index($cid=0){
		$data['title'] = 'My favorite videos - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
		$page = (int)$this->input->get('page');
		$cid = (int)$cid;
		if($page == 0) $page = 1;
		$where = array();
		$where['uid'] = $user->id;
		if($cid > 0) $where['cid'] = $cid;
		//Quantity per page
		$per_page = 15;
		$total = $this->csdb->get_nums('fav',$where);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));
		//Data
        $data['vod'] = $this->csdb->get_select('fav','*',$where,'addtime DESC',$limit);
        $data['pages'] = get_page($total,$pagejs,$page,'fav','index',$cid);
		$data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$data['user'] = $user;
		$data['cid'] = $cid;
        $this->load->view('head.tpl',$data);
        $this->load->view('fav.tpl');
        $this->load->view('bottom.tpl');
	}
}