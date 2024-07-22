<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Folder extends CI_Controller {
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
		$data['title'] = 'My video - ' . Web_Name;
		$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));
		$page = (int) $this->input->get('page');
		$sBy = $this->input->get('sort_by');
		$sTitle = $this->input->get('title');

		$cid = (int) $cid;
		if ($page == 0)
			  $page = 1;
		$where = array();


		// TODO for test
		$where['uid'] = $user->id;
		if ($cid > 0){
			  $where['folder_id'] = $cid;
		}

		//Quantity per page
		$per_page = 100;
		$total = $this->csdb->get_nums('vod', $where);
		$pagejs = ceil($total / $per_page); // Total pages
		if ($pagejs == 0)
			  $pagejs = 1;
		if ($page > $pagejs)
			  $page = $pagejs;
		$limit = array($per_page, $per_page * ($page - 1));
		//Data


		$sByQuery = 'desc';
		$sField = 'id';
		if (!empty($sBy)) {
			  if ($sTitle == 'views') {
					$sField = 'hits';
					$sByQuery = $sBy;
			  }

			  if ($sTitle == 'video_name') {
					$sField = 'name';
					$sByQuery = $sBy;
			  }

			  if ($sTitle == 'capacity') {
					$sField = 'size';
					$sByQuery = $sBy;
			  }

			  if ($sTitle == 'release_time') {
					$sField = 'addtime';
					$sByQuery = $sBy;
			  }

			  if ($sTitle == 'status') {
					$sField = 'zt';
					$sByQuery = $sBy;
			  }

			  if ($sTitle == 'thumbnail') {
					$sField = 'vid';
					$sByQuery = $sBy;
			  }
		}
		$data['vod'] = $this->csdb->get_select('vod', '*, "video" AS type', $where, $sField . ' ' . $sByQuery, $limit);
		//$data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime DESC',$limit);
		$ops = $cid > 0 ? $op . '/' . $cid : $op;
		$data['pages'] = get_page($total, $pagejs, $page, 'vod', 'index', $ops);

		$classArr = $this->csdb->get_select('class', '*', array(), 'id ASC', 30);
		$class = [];
		foreach ($classArr as $item) {
			  $class[$item->id] = $item->name;
		}
		$data['class'] = $class;

		$myClassArr = $this->csdb->get_select('myclass', '*', array('uid' => $user->id, 'fid' => 0), 'id ASC', 30);
		$myClass = [];
		foreach ($myClassArr as $item) {
			  $myClass[$item->id] = $item->name;
		}
		$data['myclass'] = $myClass;
		$data['user'] = $user;
		$data['cid'] = $cid;
		$data['op'] = $op;
		$data['sBy'] = $sBy;
		$serversData = $this->csdb->get_select('server', '*', array(), 'id ASC', 100);
		$servers = [];
		foreach ($serversData as $server) {
			  $servers[$server->id] = [
					'm3u8dir' => $server->m3u8dir,
					'cdnurl' => $server->cdnurl,
			  ];
		}
		$data['servers'] = $servers;

		$this->load->view('head.tpl', $data);
		$this->load->view('folder.tpl');
		$this->load->view('bottom.tpl');
	}

    public function edit($id=0){
		$data['title'] = 'Classification operations - '.Web_Name;
		$id = (int)$id;
		if($id == 0){
			$data['name'] = '';
			$data['fid'] = 0;
			$data['category_id'] = 0;
		}else{
			$row = $this->csdb->get_row('folder','*',array('id'=>$id,'user_id'=>$this->cookie->get('user_id')));
			if(!$row) exit('Category does not exist');
			$data['name'] = $row->name;
			$data['fid'] = $row->fid;
			$data['category_id'] = $row->category_id;
		}
		$data['id'] = $id;
		$user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
		$data['user'] = $user;
		$data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',10000);
		$data['myclass'] = $this->csdb->get_select('myclass','*',array('uid'=>$user->id,'fid'=>0),'id ASC',50);
        $this->load->view('head.tpl',$data);
        $this->load->view('folder_edit.tpl');
        $this->load->view('bottom.tpl');
	}

	public function save($id = 0){
		$id = (int)$id;
		$data['name'] = $this->input->post('folder_name',true);
		$data['category_id'] = (int)$this->input->post('category_id',true);
		if(empty($data['name'])) getjson('Folder name cannot be empty');
		if($id == 0){
			$data['user_id'] = $this->cookie->get('user_id');
			$this->csdb->get_insert('folder',$data);
		}else{
			$row = $this->csdb->get_row('folder','id',array('id'=>$id,'user_id'=>$this->cookie->get('user_id')));
			if(!$row) getjson('Folder does not exist');
			$this->db->update("folder",$data,array('id'=>$id));
		}
		getjson(array('msg'=>'Sort operation succeeded','url'=>links('vod')),1);
	}

	public function move() {
		$video_id_string = $this->input->post('video_id',true);
		$folder_id =  $this->input->post('folder_id',true);
		if(!$video_id_string){
			getjson('video id cannot be empty');
		}
		if(!$folder_id){
			getjson('folder id cannot be empty');
		}
		$video_id_array = explode(",", $video_id_string);
		$data['folder_id'] = (int) $folder_id;
		foreach ($video_id_array as $key => $video_id) {
			$data = [
				'folder_id' => $folder_id,
			];
			$this->db->update("vod",$data,array('id'=> $video_id));
		}
	
		getjson(array('msg'=>'Move folder success','url'=>links('vod')),1);
	}

	public function del($id)
	{
		$res = $this->db->delete('folder', array('id' => $id));
		getjson(array('msg'=>'delete folder success','url'=>links('vod')),1);
	}

	public function add_folder_ajax() {
		$data['name'] = $this->input->get('folder_name',true);
		$data['category_id'] = (int)$this->input->get('category_id',true);
		if(empty($data['name'])) getjson('Folder name cannot be empty');
		$data['user_id'] = $this->cookie->get('user_id');
		$folder =  $this->csdb->get_insert('folder',$data);
		$row = $this->csdb->get_row('folder','*',array('id'=>$folder));
		$ok = ['status' => 'success', 'data' => $row];
		getjson($ok, 1);
	}

}