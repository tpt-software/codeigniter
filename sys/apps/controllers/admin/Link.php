<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Link extends CI_Controller {
	function __construct(){
	    parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}

	//List of sentient connections
	public function index(){
		$page = (int)$this->input->get_post('page');
		if($page == 0) $page = 1;
		$where = array();

		//Quantity per page
		$per_page = 20;
		$total = $this->csdb->get_nums('link',$where);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));
		//Data
        $data['link'] = $this->csdb->get_select('link','*',$where,'id DESC',$limit);
        $base_url = site_url('link')."?page=";
        $data['page_data'] = page_data($total,$page,$pagejs); //Get the pagination class
        $data['page_list'] = admin_page($base_url,$page,$pagejs); //Get the pagination class
		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;
        $this->load->view('link.tpl',$data);
	}


	//Page editor
	public function edit($id = 0)
	{
 	    $id = intval($id);
		if($id==0){
		     $data['id'] = 0;
		     $data['name'] = '';
		     $data['url'] = '';
		}else{
		     $row = $this->csdb->get_row("link","*",array('id'=>$id)); 
		     $data['id'] = $id;
		     $data['name'] = $row->name;
		     $data['url'] = $row->url;
		}
        $this->load->view('link_edit.tpl',$data);
	}

	//Modify storage
	public function save($id = 0)
	{
		$id = (int)$id;
		$data['name'] = $this->input->post('name',true);
		$data['url'] = $this->input->post('url',true);
		if(empty($data['name']) || empty($data['url'])){
             getjson('Incomplete data~！');
		}

		if($id==0){
             $this->csdb->get_insert('link',$data);
		}else{
             $this->csdb->get_update('link',$id,$data);
		}
        getjson('Data action complete',1);
	}

	//Delete
	public function del(){
		$ids = $this->input->get_post('id');
		if(is_array($ids)){
			array_unique($ids);
			$ids = array_merge($ids);
			if(sizeof($ids)<1) getjson('Please select the data to delete');
			foreach ($ids as $key => $value) {
				$id = intval($value);
				if($id<1) continue;
				$this->db->delete('link',array('id'=>$id));
			}
		}else{
			$id = intval($ids);
			$this->db->delete('link',array('id'=>$id));
		}
		$info['msg'] = 'Action complete';
		$info['url'] = site_url('link')."?v=".rand(0,999);
		getjson($info,1);
	}
}