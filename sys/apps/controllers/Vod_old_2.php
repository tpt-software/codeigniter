<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Vod extends CI_Controller {
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
 public function index($op='',$cid=0){
  $data['title'] = 'My video - '.Web_Name;
  $user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
  $page = (int)$this->input->get('page');
  $sBy = $this->input->get('sort_by');

  $cid = (int)$cid;
  if($page == 0) $page = 1;
  $where = array();

  
  // TODO for test
  $where['uid'] = $user->id;
  if($cid > 0) $where['cid'] = $cid;


  //Quantity per page
  $per_page = 30;
  $total = $this->csdb->get_nums('vod',$where);
  $pagejs = ceil($total / $per_page); // Total pages
  if($pagejs == 0) $pagejs = 1;
  if($page > $pagejs) $page = $pagejs;
  $limit = array($per_page,$per_page*($page-1));
  //Data


  $sByQuery = 'desc';
  $sField = 'addtime';
  if( ! empty($sBy)) {
   $sField = 'hits';
   $sByQuery = $sBy;
  }

  $data['vod'] = $this->csdb->get_select('vod','*',$where, $sField. ' ' . $sByQuery, $limit);
        //$data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime DESC',$limit);
        $ops = $cid > 0 ? $op.'/'.$cid : $op;
        $data['pages'] = get_page($total,$pagejs,$page,'vod','index',$ops);
  $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
  $data['myclass'] = $this->csdb->get_select('myclass','*',array('uid'=>$user->id,'fid'=>0),'id ASC',15);
  $data['user'] = $user;
  $data['cid'] = $cid;
  $data['op'] = $op;
  $data['sBy'] = $sBy;

        $this->load->view('head.tpl',$data);
        if($op == 'pic' || (defined('MOBILE') && $op!='txt')){
         $this->load->view('vod_my_pic.tpl');
        }else{
         $this->load->view('vod_my.tpl');
        }
        $this->load->view('bottom.tpl');
 }

 //Square video
 public function square($op='',$cid=0){
  $data['title'] = 'Video square - '.Web_Name;
  $user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
  $page = (int)$this->input->get('page');
  $cid = (int)$cid;
  if($page == 0) $page = 1;
  $where = array();
  $where['vip'] = 0;
  if($cid > 0) $where['cid'] = $cid;
  //Quantity per page
  $per_page = 15;
  $total = $this->csdb->get_nums('vod',$where);
  $pagejs = ceil($total / $per_page); // Total pages
  if($pagejs == 0) $pagejs = 1;
  if($page > $pagejs) $page = $pagejs;
  $limit = array($per_page,$per_page*($page-1));
  //Data
        $data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime DESC',$limit);
        $ops = $cid > 0 ? $op.'/'.$cid : $op;
        $data['pages'] = get_page($total,$pagejs,$page,'vod','square',$ops);
  $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
  $data['user'] = $user;
  $data['cid'] = $cid;
  $data['op'] = $op;
        $this->load->view('head.tpl',$data);
        if($op == 'pic' || (defined('MOBILE') && $op!='txt')){
         $this->load->view('vod_square_pic.tpl');
        }else{
         $this->load->view('vod_square.tpl');
        }
        $this->load->view('bottom.tpl');
 }

 //Video search
 public function search(){
  $data['title'] = 'Video search - '.Web_Name;
  $user = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
  $page = (int)$this->input->get('page');
  $key = $this->input->get_post('key',true);;
  if($page == 0) $page = 1;
  $like = $where = array();
  if(!empty($key)) $like['name'] = $key;
        $where['vip'] = 0;

  $where['uid'] = $user->id;
//Quantity per page
  $per_page = 30;
  $total = $this->csdb->get_nums('vod',$where,$like);
  $pagejs = ceil($total / $per_page); // Total pages
  if($pagejs == 0) $pagejs = 1;
  if($page > $pagejs) $page = $pagejs;
  $limit = array($per_page,$per_page*($page-1));
  //Data
        $data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime DESC',$limit,$like);
        $data['pages'] = get_page($total,$pagejs,$page,'vod','search',0,'key='.urlencode($key));
  $data['user'] = $user;
  $data['key'] = $key;
  $data['nums'] = $total;
  $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
        $this->load->view('head.tpl',$data);
        $this->load->view('vod_search.tpl');
        $this->load->view('bottom.tpl');
 }

 //Edit video
 public function edit($id){
  $id = (int)$id;
  if($id == 0) exit('ID is empty');
  $row = $this->csdb->get_row('vod','*',array('id'=>$id));
  if(!$row || $row->uid != $this->cookie->get('user_id')){
   exit('Video does not exist');
  }
  $data['title'] = 'Edit video - '.Web_Name;
  $data['vod'] = $row;
  $data['class'] = $this->csdb->get_select('class','*',array(),'id ASC',30);
  $data['myclass'] = $this->csdb->get_select('myclass','*',array('uid'=>$row->uid,'fid'=>0),'id ASC',100);
  $data['user'] = $this->csdb->get_row('user','*',array('id'=>$this->cookie->get('user_id')));
  if($row->fid > 0){
   $data['server'] = $this->csdb->get_row_arr('server','*',array('id'=>$row->fid));
  }else{
   $data['server'] = array();
  }
  $this->load->view('head.tpl',$data);
        $this->load->view('vod_edit.tpl');
        $this->load->view('bottom.tpl');
 }

 //Modify the video storage
 public function save($id){
  $id = (int)$id;
  if($id == 0) getjson('Video ID is empty');
  $name = $this->input->post('name',true);
  $cid = (int)$this->input->post('cid',true);
  $mycid = (int)$this->input->post('mycid',true);
  if(empty($name)) getjson('Video title cannot be empty');
  $row = $this->csdb->get_row('vod','uid',array('id'=>$id));
  if(!$row || $row->uid != $this->cookie->get('user_id')){
   getjson('Video does not exist');
  }
  $edit['name'] = $name;
  $edit['cid'] = $cid;
  $edit['mycid'] = $mycid;
  $this->db->update("vod",$edit,array('id'=>$id));
  getjson(array('msg'=>'Video modification action complete','url'=>links('vod','edit',$id)),1);
 }
 // Add Delete Button
 public function del($id){
  
  $id = (int)$id;
  if($id == 0) exit('ID is empty');
  $row = $this->csdb->get_row('vod','*',array('id'=>$id));
  if(!$row || $row->uid != $this->cookie->get('user_id')){
   exit('Video does not exist');
  }
  
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
  
  $info['msg'] = 'Action complete';
  $info['url'] = site_url('vod')."?v=".rand(0,999);
  getjson($info,1);
 }
//Delete
 public function delAll() {
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
}
