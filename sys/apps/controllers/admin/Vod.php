<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Vod extends CI_Controller {
 function __construct(){
     parent::__construct();
  //Load member model
  $this->load->model('admin');
        //Judgment login
  $this->admin->login();
        //Current template
  $this->load->get_templates();
 }

 //Video list
 public function index(){
  $page = (int)$this->input->get_post('page');
  $zt = (int)$this->input->get_post('zt');
  $cid = (int)$this->input->get_post('cid');
  $vip = (int)$this->input->get_post('vip');
  $fid = (int)$this->input->get_post('fid');
  $zd = $this->input->get_post('zd',true);
  $key = $this->input->get_post('key',true);
  $kstime = $this->input->get_post('kstime',true);
  $jstime = $this->input->get_post('jstime',true);


  $sField = $this->input->get_post('sort_field');
  $sBy = $this->input->get_post('sort_by');


  if($page == 0) $page = 1;
  $where = $like = array();

  if($cid > 0) $where['cid'] = $cid;
  if($fid > 0) $where['fid'] = $fid;
  if($zt > 0) $where['zt'] = $zt-1;
  if($vip > 0) $where['vip'] = $vip-1;
  if(!empty($key)){
   if($zd == 'name'){
    $like['name'] = $key;
   }else{
    $where[$zd] = (int)$key;
   }
  }
  if(!empty($kstime)) $where['addtime>'] = strtotime($kstime)-1;
  if(!empty($jstime)) $where['addtime<'] = strtotime($kstime)+1;

  $data['zt'] = $zt;
  $data['vip'] = $vip;
  $data['cid'] = $cid;
  $data['fid'] = $fid;
  $data['zd'] = $zd;
  $data['key'] = $key;
  $data['kstime'] = $kstime;
  $data['jstime'] = $jstime;

  $data['sField'] = $sField;
  $data['sBy'] = $sBy;

  // echo '<pre>';print_r($data);
  // exit;

  //Quantity per page
  $per_page = 100;
  $total = $this->csdb->get_nums('vod',$where,$like);
  $pagejs = ceil($total / $per_page); // Total pages
  if($pagejs == 0) $pagejs = 1;
  if($page > $pagejs) $page = $pagejs;
  $limit = array($per_page,$per_page*($page-1));
  //Data
  
  if(empty($sField)) {
   $sField = 'addtime';
   $sBy = 'desc';
  }

	$data['vod'] = $this->csdb->get_select('vod','*',$where, $sField . ' ' . $sBy, $limit,$like);
	//$data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime DESC',$limit,$like);
	$base_url = site_url('vod')."?cid=".$cid."&fid=".$fid."&zt=".$zt."&vip=".$vip."&zd=".$zd."&key=".urlencode($key)."&kstime=".$kstime."&jstime=".$jstime."&page=";
	$data['page_data'] = page_data($total,$page,$pagejs); //Get the pagination class
	$data['page_list'] = admin_page($base_url,$page,$pagejs); //Get the pagination class
	
	$vlistData = $this->csdb->get_select('class','*',array(),'id DESC',100);
	$vlist = [];
	foreach ($vlistData as $item) {
		$vlist[$item->id] = $item->name;
	}
	$data['vlist'] = $vlist;

	$serverData = $this->csdb->get_select('server','*',array(),'id DESC',100);
	$server = [];
	foreach ($serverData as $item) {
		$server[$item->id] = $item->name;
	}
	$data['server'] = $server;

	$myclassData = $this->csdb->get_select('myclass','*',array(),'id DESC',100);
	$myclass = [];
	foreach ($myclassData as $item) {
		$myclass[$item->id] = $item->name;
	}
	$data['myclass'] = $myclass;
		
		//   --------------- handle total size ---------------   
      $array_size = $this->csdb->get_size_vod('vod', 'size');
      $size_values = array_column($array_size, 'size'); 
      $total_size = array_sum($size_values);

      // converse number to TB
      $total_size_tb = $total_size / (1024 * 1024 * 1024 * 1024); 
      $data['sizecus'] = number_format($total_size_tb, 2);

      $header = $this->load->view('header.tpl', '', true);
      $leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
      $data['header'] = $header;
      $data['leftsidebar'] = $leftsidebar;
      
      // render
        $this->load->view('vod.tpl',$data);
 }

 //Detailed
 public function show($id=0){
  $id = intval($id);
  if($id == 0) exit('Video does not exist~');
  $vod = $this->csdb->get_row('vod','*',array('id'=>$id));
  $data['vod'] = $vod;
  $this->load->view('vod_show.tpl',$data);
 }

 //Modify
 public function edit($id=0){
  $id = intval($id);
  if($id == 0){
   exit('Video does not exist~');
  }
  $vod = $this->csdb->get_row('vod','*',array('id'=>$id));
  $data['vod'] = $vod;
  $data['vlist'] = $this->csdb->get_select('class','*',array(),'id DESC',100);
  $this->load->view('vod_edit.tpl',$data);
 }

 //Storage
 public function save($id=0){
  $id = intval($id);
  if($id==0) getjson('Video ID is empty');
  $data['name'] = $this->input->post('name',true);
  $data['cid'] = (int)$this->input->post('cid',true);
  $data['zt'] = (int)$this->input->post('zt',true);
  $data['filepath'] = $this->input->post('filepath',true);
  if(empty($data['name']) || empty($data['filepath'])) getjson('Incomplete data');
  $this->db->update("vod",$data,array('id'=>$id));
  getjson('Video modification action complete',1);
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
    $row = $this->csdb->get_row('vod','*',array('id'=>$id));
    if($row){
     $res = $this->db->delete('vod',array('id'=>$id));
     if($res){
      //Delete favorite
      $this->db->delete('fav',array('did'=>$id));
      //Minus hard disk capacity
      if($row->fid > 0){
       $rows = $this->csdb->get_row('server','size',array('id'=>$row->fid));
       $xsize = $rows->size-$row->size;
       if($xsize < 0) $xsize = 0;
       $this->csdb->get_update('server',$row->fid,array('size'=>$xsize));
       //Delete remote server files
       if(Del_Mp4 == 1 || Del_M3u8 == 1){
        $apiurl = $rows->apiurl.'api.php?ac=del&key='.$rows->apikey;
        $post['m3u8'] = Del_M3u8;
        $post['mp4'] = Del_Mp4;
        $post['filepath'] = $row->filepath;
        $post['vid'] = $row->vid;
        $post['addtime'] = $row->addtime;
        geturl($apiurl,$post);
       }
      }else{
       //Delete original file
       if(Del_Mp4 == 1){
        unlink($row->filepath);
       }
       //Delete slice file
       if(Del_M3u8 == 1){
        deldir(m3u8_dir($row->vid,$row->addtime));
       }
      }
     }
    }
   }
  }else{
   $id = intval($ids);
   $row = $this->csdb->get_row('vod','*',array('id'=>$id));
   if($row){
    $res = $this->db->delete('vod',array('id'=>$id));
    if($res){
     //Delete favorite
     $this->db->delete('fav',array('did'=>$id));
     //Minus hard disk capacity
     if($row->fid > 0){
      $rows = $this->csdb->get_row('server','*',array('id'=>$row->fid));
      $xsize = $rows->size-$row->size;
      if($xsize < 0) $xsize = 0;
      $this->csdb->get_update('server',$row->fid,array('size'=>$xsize));
      //Delete remote server files
      if(Del_Mp4 == 1 || Del_M3u8 == 1){
       $apiurl = $rows->apiurl.'api.php?ac=del&key='.$rows->apikey;
       $post['m3u8'] = Del_M3u8;
       $post['mp4'] = Del_Mp4;
       $post['filepath'] = $row->filepath;
       $post['vid'] = $row->vid;
       $post['addtime'] = $row->addtime;
       geturl($apiurl,$post);
      }
     }else{
      //Delete original file
      if(Del_Mp4 == 1){
       unlink($row->filepath);
      }
      //Delete slice file
      if(Del_M3u8 == 1){
       deldir(m3u8_dir($row->vid,$row->addtime));
      }
     }
    }
   }
  }
  $info['msg'] = 'Action complete';
  $info['url'] = site_url('vod')."?v=".rand(0,999);
  getjson($info,1);
 }

 //Get transcoding status
 public function ajax(){
  $ids = $this->input->post('did',true);
  $res = $this->csdb->get_select('vod','id,zt',array('id'=>$ids),'id DESC',20);
  echo json_encode($res);
 }
}
