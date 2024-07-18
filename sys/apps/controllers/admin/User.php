<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class User extends CI_Controller {
	function __construct(){
	    parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}

	//Member list
	public function index(){
		$page = (int)$this->input->get_post('page');
		$zt = (int)$this->input->get_post('zt');
		$vip = (int)$this->input->get_post('vip');
		$zd = $this->input->get_post('zd',true);
		$key = $this->input->get_post('key',true);
		$kstime = $this->input->get_post('kstime',true);
		$jstime = $this->input->get_post('jstime',true);
		if($page == 0) $page = 1;
		$where = $like = array();

		$sField = $this->input->get_post('sort_field');
  		$sBy = $this->input->get_post('sort_by');
		
		if($zt > 0) $where['zt'] = $zt-1;
		if($vip > 0) $where['vip'] = $vip-1;
		if(!empty($key)){
			if($zd == 'id'){
				$where[$zd] = (int)$key;
			}else{
				$like[$zd] = $key;
			}
		}
		if(!empty($kstime)) $where['addtime>'] = strtotime($kstime)-1;
		if(!empty($jstime)) $where['addtime<'] = strtotime($jstime)+1;
		if(empty($sField)) {
			$sField = 'id';
			$sBy = 'desc';
		}
		$data['zt'] = $zt;
		$data['vip'] = $vip;
		$data['zd'] = $zd;
		$data['key'] = $key;
		$data['kstime'] = $kstime;
		$data['jstime'] = $jstime;
		$data['sField'] = $sField;
  		$data['sBy'] = $sBy;

		//Quantity per page
		$per_page = 20;
		$total = $this->csdb->get_nums('user',$where,$like);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));

		//Data
		$sql = 'select user.*,total_video from user  left join (select uid,count(id) as total_video from vod group by uid) as vod on user.id = vod.uid' ;
		if($zt > 0) {
			$sql .= ' where zt = ' . ($zt - 1);
		}
		if($vip > 0) {
			if (strpos($sql, 'where') !== false) {
				$sql .= ' and vip = ' . ($vip - 1);
			} else {
				$sql .= ' where vip = ' . ($vip - 1);
			}
		}
		
		if(!empty($key)){
			if($zd == 'id'){
				if (strpos($sql, 'where')  !== false) {
					$sql .= ' and id = '  . (int)$key;
				} else {
					$sql .= ' where id = ' . (int)$key;
				}
			}else{
				if (strpos($sql, 'where')  !== false) {
					$sql .= ' and ' . $zd . ' like "%'  . $key . '%"';
				} else {
					$sql .= ' where ' . $zd . ' like "%'  . $key . '%"';
				}
			}
		}
		if(!empty($kstime)) {
			if (strpos($sql, 'where') !== false) {
				$sql .= ' and addtime > ' . (strtotime($kstime)-1);
			} else {
				$sql .= ' where addtime > ' . (strtotime($kstime)-1);
			}
		}
		if(!empty($jstime)) {
			if (strpos($sql, 'where') !== false) {
				$sql .= ' and addtime < ' . (strtotime($jstime)+1);
			} else {
				$sql .= ' where addtime < ' . (strtotime($jstime)+1);
			}
		}
		$sql .= ' order by ' . $sField . ' ' . $sBy;
		$sql .= ' limit ' . $per_page*($page-1)  . ',' . $per_page ;
		
	
		$data['user'] = $this->csdb->get_sql($sql);

        $base_url = site_url('user')."?zt=".$zt."&vip=".$vip."&zd=".$zd."&key=".urlencode($key)."&kstime=".$kstime."&jstime=".$jstime."&page=";
        $data['page_data'] = page_data($total,$page,$pagejs); //Get the pagination class
        $data['page_list'] = admin_page($base_url,$page,$pagejs); //Get the pagination class

		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;
		
        $this->load->view('user.tpl',$data);
	}

	//Modify
	public function edit($id=0){
		$id = intval($id);
		if($id == 0){
			exit('Member does not exist~');
		}
		$data['user'] = $this->csdb->get_row('user','*',array('id'=>$id));
		$this->load->view('user_edit.tpl',$data);
	}

	//Storage
	public function save($id=0){
		$id = intval($id);
		if($id==0) getjson('Member ID is empty');
		$pass = $this->input->post('pass',true);
		$data['name'] = $this->input->post('name',true);
		$data['qq'] = $this->input->post('qq',true);
		$data['email'] = $this->input->post('email',true);
		$data['url'] = $this->input->post('url',true);
		$data['zt'] = (int)$this->input->post('zt',true);
		$data['vip'] = (int)$this->input->post('vip',true);
		if(!empty($pass)) $data['pass'] = md5($pass);
		if(empty($data['name'])) getjson('Account cannot be empty');
		$this->db->update("user",$data,array('id'=>$id));
		getjson('Member modification action completed',1);
	}

	//Delete
	public function del(){
		$ids = $this->input->get_post('id');
		if(is_array($ids)){
			array_unique($ids);
			$ids = array_merge($ids);
			if(sizeof($ids)<1) getjson('Please select a member to delete');
			foreach ($ids as $key => $value) {
				$id = intval($value);
				if($id<1) continue;
				$this->db->delete('user',array('id'=>$id));
			}
		}else{
			$id = intval($ids);
			$this->db->delete('user',array('id'=>$id));
		}
		$info['msg'] = 'Action complete';
		$info['url'] = site_url('user')."?v=".rand(0,999);
		getjson($info,1);
	}
}