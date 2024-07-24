<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Lists extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
        //Judgment login
		$this->user->login();
        //Current template
		$this->load->get_templates();
	}

	//My category
	public function index(){
		$data['title'] = 'My category - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));

		$where = array('fid'=>0,'uid'=>$user->id);
		//Data
        $data['myclass'] = $this->csdb->get_select('myclass','*',$where,'id ASC',100);
        $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',10000);
		$data['user'] = $user;
        $this->load->view('head.tpl',$data);
        $this->load->view('list.tpl');
        $this->load->view('bottom.tpl');
	}

	//Add and modify categories
	public function edit($id=0){
		$data['title'] = 'Classification operations - '.Web_Name;
		$id = (int)$id;
		if($id == 0){
			$data['name'] = '';
			$data['fid'] = 0;
		}else{
			$row = $this->csdb->get_row('myclass','*',array('id'=>$id,'uid'=>$this->cookie->get('user_id')));
			if(!$row) exit('Category does not exist');
			$data['name'] = $row->name;
			$data['fid'] = $row->fid;
		}
		$data['id'] = $id;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
		$data['user'] = $user;
		$data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',10000);
		$data['myclass'] = $this->csdb->get_select('myclass','*',array('uid'=>$user->id,'fid'=>0),'id ASC',50);
        $this->load->view('head.tpl',$data);
        $this->load->view('list_edit.tpl');
        $this->load->view('bottom.tpl');
	}

		public function del($id =0){
		
		$id = (int)$id;
		if($id == 0) exit('ID is empty');
		
		$row = $this->csdb->get_row('myclass','*',array('id'=>$id,'uid'=>$this->cookie->get('user_id')));
		if(!$row) exit('Category does not exist');
		
		if($row){
			$res = $this->db->delete('myclass',array('id'=>$id));
		}
		
		$info['msg'] = 'Action complete';
		$info['url'] = site_url('vod')."?v=".rand(0,999);
		getjson($info,1);
	}

	//Add, modify storage
	public function save($id=0){
		$id = (int)$id;
		$data['name'] = $this->input->post('name',true);
		$data['fid'] = (int)$this->input->post('fid',true);
		if(empty($data['name'])) getjson('Category name cannot be empty');
		if($id == 0){
			$data['uid'] = $this->cookie->get('user_id');
			$this->csdb->get_insert('myclass',$data);
		}else{
			$row = $this->csdb->get_row('myclass','id',array('id'=>$id,'uid'=>$this->cookie->get('user_id')));
			if(!$row) getjson('Category does not exist');
			$this->db->update("myclass",$data,array('id'=>$id));
		}
		getjson(array('msg'=>'Sort operation succeeded','url'=>links('lists')),1);
	}

	//Category Video
	public function vod($cid=0){
		$data['title'] = 'Category Video - '.Web_Name;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
		$page = (int)$this->input->get('page');
		$cid = (int)$cid;
		$class = $this->csdb->get_row('myclass','*',array('id'=>$cid,'uid'=>$this->cookie->get('user_id')));
		if(!$class) exit('Category does not exist');
		if($class->fid == 0) $cid = getcid($cid);
		if($page == 0) $page = 1;
		$where = array();
		$where['uid'] = $user->id;
		if(!empty($cid)) $where['mycid'] = $cid;
		//Quantity per page
		$per_page = 100;
		$total = $this->csdb->get_nums('vod',$where);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));
		//Data
        $data['vod'] = $this->csdb->get_select('vod','*, "video" AS type',$where,'addtime DESC',$limit);
        $data['pages'] = get_page($total,$pagejs,$page,'lists','vod',$cid);
		$data['user'] = $user;
		$data['cid'] = $cid;
		$data['list'] = $class;
		$data['nums'] = $total;
		$data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',10000);
        $this->load->view('head.tpl',$data);
        $this->load->view('list_vod.tpl');
        $this->load->view('bottom.tpl');
	}
}