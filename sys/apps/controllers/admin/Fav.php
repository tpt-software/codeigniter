<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Fav extends CI_Controller {
	function __construct(){
	    parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}

	//Video favorite list
	public function index(){
		$page = (int)$this->input->get_post('page');
		$cid = (int)$this->input->get_post('cid');
		$did = (int)$this->input->get_post('did');
		$kstime = $this->input->get_post('kstime',true);
		$jstime = $this->input->get_post('jstime',true);
		if($page == 0) $page = 1;
		$where = array();

		if($cid > 0) $where['cid'] = $cid;
		if($did > 0) $where['did'] = $did;
		if(!empty($kstime)) $where['addtime>'] = strtotime($kstime)-1;
		if(!empty($jstime)) $where['addtime<'] = strtotime($kstime)+1;

		$data['cid'] = $cid;
		$data['did'] = $did;
		$data['kstime'] = $kstime;
		$data['jstime'] = $jstime;

		//Quantity per page
		$per_page = 20;
		$total = $this->csdb->get_nums('fav',$where);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));
		//Data
        $data['vod'] = $this->csdb->get_select('fav','*',$where,'addtime DESC',$limit);
        $base_url = site_url('fav')."?cid=".$cid."&did=".$did."&kstime=".$kstime."&jstime=".$jstime."&page=";
        $data['page_data'] = page_data($total,$page,$pagejs); //Get the pagination class
        $data['page_list'] = admin_page($base_url,$page,$pagejs); //Get the pagination class
        $data['vlist'] = $this->csdb->get_select('class','*',array(),'id DESC',100);

		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;
		
        $this->load->view('fav.tpl',$data);
	}

	//Delete
	public function del(){
		$ids = $this->input->get_post('id');
		if(is_array($ids)){
			array_unique($ids);
			$ids = array_merge($ids);
			if(sizeof($ids)<1) getjson('Please select the file to delete');
			foreach ($ids as $key => $value) {
				$id = intval($value);
				if($id<1) continue;
				$this->db->delete('fav',array('id'=>$id));
			}
		}else{
			$id = intval($ids);
			$this->db->delete('fav',array('id'=>$id));
		}
		$info['msg'] = 'Action complete';
		$info['url'] = site_url('fav')."?v=".rand(0,999);
		getjson($info,1);
	}
}