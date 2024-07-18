<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Ting extends CI_Controller {
	function __construct(){
	    parent::__construct();
	    //Load member model
		$this->load->model('user');
	}

	public function index(){
		$id = (int)$this->input->get_post('id');
		if($id == 0){
			$row = $this->csdb->get_row('vod','*',array('zt'=>0),'id ASC');
			if(!$row) exit('There are currently no videos that need to be transcoded');
		}else{
			$row = $this->csdb->get_row('vod','*',array('id'=>$id));
			if(!$row) exit('Video does not exist');
			if($row->zt > 1) exit('Video is transcoded');
			if($row->zt == 1) exit('Video transcoding...');
		}
		$zmnum = 10;
		if($row->fid > 0){
			$rows = $this->csdb->get_row('server','*',array('id'=>$row->fid));
			if($rows) $zmnum = $rows->zmnum;
		}
		//Determine the number of transcoding processes
		$num = $this->csdb->get_nums('vod',array('fid'=>$row->fid,'zt'=>1));
		if($num >= $zmnum){
			exit('The transcoding process has been limited, please wait...');
		}
		//Close the browser and continue
		ignore_user_abort(true);
		if($row->fid > 0){
			//Modify transcoding time
			$this->csdb->get_update('vod',$row->id,array('zt'=>1,'zmtime'=>time()));
			//Start transcoding
			get_log(date('Y-m-d H:i:s').'：video：'.$row->name.'--->Transcoding started');
			$post['filepath'] = $row->filepath;
			$post['vid'] = $row->vid;
			$post['id'] = $row->id;
			$post['addtime'] = $row->addtime;
			$apiurl = $rows->apiurl.'api.php?ac=zm&key='.$rows->apikey;
			echo geturl($apiurl,$post);
		}else{
			//File path
			$mp4file = $row->filepath;
			$m3u8path = m3u8_dir($row->vid,$row->addtime);
			//Create folder
			mkdirss($m3u8path);
			//Modify transcoding time
			$this->csdb->get_update('vod',$row->id,array('zt'=>1,'zmtime'=>time()));
			//Start transcoding
			get_log(date('Y-m-d H:i:s').'：video：'.$row->name.'--->Transcoding started');
			$this->load->library('ffmpeg');
			$res = $this->ffmpeg->transcode($mp4file,$m3u8path);
			//Modify transcoding status
			if($res == 'm3u8ok'){
				$this->csdb->get_update('vod',$row->id,array('zt'=>2));
				get_log(date('Y-m-d H:i:s').'：video：'.$row->name.'--->Transcoding complete');
				echo 'Video ID：'.$row->id.'--->Transcoding complete';
			}else{
				$this->csdb->get_update('vod',$row->id,array('zt'=>3));
				get_log(date('Y-m-d H:i:s').'：video：'.$row->name.'--->Transcoding failed');
				echo 'Video ID：'.$row->id.'--->Transcoding failed';
			}
		}
	}
}