<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Play extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
        //Current template
		$this->load->get_templates();
	}

	public function index($vid=''){
		$vid = safe_replace($vid);
		if(empty($vid)) exit('Video vid is empty');
		$row = $this->csdb->get_row('vod','*',array('vid'=>$vid));
		if(!$row) exit('Video does not exist');
		if($row->zt == 0) exit('Video is not transcoded');
		if($row->zt == 1) exit('Video transcoding...');
		if($row->zt == 3) exit('Video transcoding failed please REUPLOAD this video again');
		$rows = array();
        if($row->fid > 0){
            $rows = $this->csdb->get_row_arr('server','*',array('id'=>$row->fid));
        }
		//Increase the number of plays
		$hits = $row->hits+1;
		$this->csdb->get_update('vod',$row->id,array('hits'=>$hits));
		
		//File path
		if ($row->is_remote_m3u8) {
			$data['m3u8url'] = $row->m3u8_url;
			$data['picurl'] = $row->thumnail_url;
		} else {
			$data['m3u8url'] = m3u8_link($row->vid,$row->addtime,'m3u8',1,$rows);
			$data['picurl'] = m3u8_link($row->vid,$row->addtime,'pic',1,$rows);
		}
		
		$data['title'] = $row->name.'';
		$data['vod'] = $row;
		$this->load->view('play.tpl',$data);
	}
}