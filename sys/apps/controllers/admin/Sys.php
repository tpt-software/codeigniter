<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Sys extends CI_Controller {
	function __construct(){
	    parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}

	//Administrator list
	public function index(){
		//Data
        $data['admin'] = $this->csdb->get_select('admin','*',array(),'id DESC',100);
		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;
        $this->load->view('sys.tpl',$data);
	}

	//Modify
	public function edit($id=0){
		$id = intval($id);
		if($id == 0){
			$data['name'] = '';
			$data['nichen'] = '';
		}else{
			$row = $this->csdb->get_row('admin','*',array('id'=>$id));
			if(!$row) exit('Account does not exist');
			$data['name'] = $row->name;
			$data['nichen'] = $row->nichen;
		}
		$data['id'] = $id;
		$this->load->view('sys_edit.tpl',$data);
	}

	//Storage
	public function save($id=0){
		$id = intval($id);
		$name = $this->input->post('name',true);
		$pass = $this->input->post('pass',true);
		$nichen = $this->input->post('nichen',true);
		$data['name'] = $name;
		$data['nichen'] = $nichen;
		if($id==0){
			if(empty($name) || empty($pass)) getjson('Account and password cannot be empty');
			$data['pass'] = md5($pass);
			$this->db->insert('admin',$data);
		}else{
			if(!empty($pass)) $data['pass'] = md5($pass);
			$this->db->update("admin",$data,array('id'=>$id));
		}
		getjson('Data action complete',1);
	}

	//Delete
	public function del(){
		$ids = $this->input->get_post('id');
		if(is_array($ids)){
			array_unique($ids);
			$ids = array_merge($ids);
			if(sizeof($ids)<1) getjson('Please select the account to delete');
			foreach ($ids as $key => $value) {
				$id = intval($value);
				if($id<1 || $id == $this->cookie->get('admin_id')) continue;
				$this->db->delete('admin',array('id'=>$id));
			}
		}else{
			$id = intval($ids);
			if($id == $this->cookie->get('admin_id')){
				getjson('Can not delete itself');
			}
			$this->db->delete('admin',array('id'=>$id));
		}
		$info['msg'] = 'Action complete';
		$info['url'] = site_url('sys')."?v=".rand(0,999);
		getjson($info,1);
	}
}