<?php
defined('BASEPATH') OR exit('No direct script access allowed');
class Api extends CI_Controller {
	function __construct(){
	    parent::__construct();
		$this->load->model('user');
        $this->load->get_templates();
	}

	public function index(){
		$ac = $this->input->get('ac',true);
		$rid = (int)$this->input->get('rid',true);
		$wd = $this->input->get('wd',true);
		$cid = (int)$this->input->get('t',true);
		$h = (int)$this->input->get('h',true);
		$ids = $this->input->get('ids',true);
		$page = (int)$this->input->get('pg',true);
		//SQL filtering
		$wd = safe_replace(rawurldecode($wd));
		if($ac!=='list') $ac='vod';

		$where = $like = array();
		$where['vip'] = 0;
		//Classification
		if($cid>0) $where['cid'] = $cid;
		//Number of days
		if($h>0){
			if($h==24){
				$time = strtotime(date('Y-m-d'));
				$where['addtime>'] = $time;
			}else{
				$time1 = time()-3600*$h;
				$time2 = date('Y-m-d 0:0:0',$time1);
				$time = strtotime($time2);
				$where['addtime>'] = $time;
			}
		}
		//Search
		if(!empty($wd)) $like['name'] = $wd;

		//Select collection
		if(preg_match('/^([0-9]+[,]?)+$/', $ids)){
			$where['id'] = $ids;
		}

		//Quantity per page
		$size = 30;
		//The total amount
		$nums = $this->csdb->get_nums('vod',$where,$like);
		//Total pages
		$pagejs = ceil($nums / $size);
		if($page > $pagejs) $page=$pagejs;
		if($page==0) $page = 1;
		if($nums<$size) $size=$nums;

		//Offset
		$limit = array($size,$size*($page-1));
		//Datasheets
		$data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime desc',$limit,$like);
		//Secondary classification
		if($ac=='list'){
			$data['class'] = $this->csdb->get_select('class','*','','id asc',50);
		}else{
			$data['class'] = array();
		}
		$data['page'] = $page;
		$data['pagejs'] = $pagejs;
		$data['nums'] = $nums;
		$data['size'] = $size;
		header("Content-type:text/xml;charset=utf-8");
		$this->load->view('api/'.$ac.'.tpl',$data);
	}

	//VIP member
	public function vip($user = ''){
		if(empty($user)) exit('VIP account is empty');
		$res = $this->csdb->get_row('user','id,vip',array('name'=>safe_replace($user)));
		if(!$res || $res->vip == 0) exit('VIP account does not exist');
		$ac = $this->input->get('ac',true);
		$rid = (int)$this->input->get('rid',true);
		$wd = $this->input->get('wd',true);
		$cid = (int)$this->input->get('t',true);
		$h = (int)$this->input->get('h',true);
		$ids = $this->input->get('ids',true);
		$page = (int)$this->input->get('pg',true);
		//SQL filtering
		$wd = safe_replace(rawurldecode($wd));
		if($ac!=='list') $ac='vod';

		$where = $like = array();
		$where['uid'] = $res->id;
		//Classification
		if($cid>0) $where['cid'] = $cid;
		//Number of days
		if($h>0){
			if($h==24){
				$time = strtotime(date('Y-m-d'));
				$where['addtime>'] = $time;
			}else{
				$time1 = time()-3600*$h;
				$time2 = date('Y-m-d 0:0:0',$time1);
				$time = strtotime($time2);
				$where['addtime>'] = $time;
			}
		}
		//Search
		if(!empty($wd)) $like['name'] = $wd;

		//Select collection
		if(preg_match('/^([0-9]+[,]?)+$/', $ids)){
			$where['id'] = $ids;
		}

		//Quantity per page
		$size = 30;
		//The total amount
		$nums = $this->csdb->get_nums('vod',$where,$like);
		//Total pages
		$pagejs = ceil($nums / $size);
		if($page > $pagejs) $page=$pagejs;
		if($page==0) $page = 1;
		if($nums<$size) $size=$nums;
		//Offset
		$limit = array($size,$size*($page-1));
		//Datasheets
		$data['vod'] = $this->csdb->get_select('vod','*',$where,'addtime desc',$limit,$like);
		//Secondary classification
		if($ac=='list'){
			$data['class'] = $this->csdb->get_select('class','*','','xid asc',50);
		}else{
			$data['class'] = array();
		}
		$data['page'] = $page;
		$data['pagejs'] = $pagejs;
		$data['nums'] = $nums;
		$data['size'] = $size;
		header("Content-type:text/xml;charset=utf-8");
		$this->load->view('api/'.$ac.'.tpl',$data);
	}

	// public function upload(){
	// 	if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
	// 		return $this->output
	// 		->set_content_type('application/json')
	// 		->set_status_header(200)
	// 		->set_output(json_encode([
	// 			'status' => 'error',
	// 			'msg' => 'Method is not allowed!',
	// 		]));
	// 	}
	// 	try {
	// 		set_time_limit(0);
	// 		$apikey = trim($this->input->get_post('apikey'));
	// 		$cid = $this->input->get_post('cid');
	// 		$mycid = $this->input->get_post('mycid');
	// 		$fid = $this->input->get_post('fid');

	// 		if (empty($apikey)) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'apikey is required!'
	// 			]));
	// 		}
	// 		if (empty($cid)) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'cid is required!'
	// 			]));
	// 		}
	// 		if (empty($fid)) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'fid is required!'
	// 			]));
	// 		}
		
	// 		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
	// 		if (!$user) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(401)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'Unauthorized!'
	// 			]));
	// 		}
	// 		$add['uid'] = $user->id;

	// 		$videoclass = $this->csdb->get_row('class','*',array('id' => $cid));
	// 		if (!$videoclass) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'cid is not correct!'
	// 			]));
	// 		}
	// 		// $add['cid'] = $cid;

	// 		if ($mycid) {
	// 			$myclass = $this->csdb->get_row('myclass','*',array('id' => $mycid,'uid' => $user->id, 'fid' => 0));
	// 			if (!$myclass) {
	// 				return $this->output
	// 				->set_content_type('application/json')
	// 				->set_status_header(200)
	// 				->set_output(json_encode([
	// 					'status' => 'error',
	// 					'msg' => 'mycid is not correct!'
	// 				]));
	// 			}
	// 			// $add['mycid'] = $mycid;
	// 		} 
		
	// 		$server = $this->csdb->get_row('server','*',array('id' => $fid,'vip' => $user->vip));
	// 		if (!$server) {
	// 			return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'fid is not correct!'
	// 			]));
	// 		}
	// 		// $add['fid'] = $fid;
			
	// 		if ($_FILES['video']['error'] === UPLOAD_ERR_OK) {
	// 			$file_tmp = $_FILES['video']['tmp_name'];
    // 			$file_name = $_FILES['video']['name'];

	// 			$str['cid'] = $cid;
	// 			$str['mycid'] = $mycid;
	// 			$str['id'] = (string)$user->id;
	// 			$str['vip'] = $user->vip;
	// 			$str['login'] = md5($user->id . $user->name . $user->pass);
	// 			$key = sys_auth(json_encode($str), 0, $server->apikey);

	// 			$curl = curl_init();
	// 			curl_setopt_array($curl, array(
	// 				CURLOPT_URL => $server->apiurl . 'upload.php?key=' . $key,
	// 				CURLOPT_RETURNTRANSFER => true,
	// 				CURLOPT_ENCODING => '',
	// 				CURLOPT_MAXREDIRS => 10,
	// 				CURLOPT_TIMEOUT => 0,
	// 				CURLOPT_SSL_VERIFYHOST => 0,
	// 				CURLOPT_SSL_VERIFYPEER => 0,
	// 				CURLOPT_FOLLOWLOCATION => true,
	// 				CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	// 				CURLOPT_CUSTOMREQUEST => 'POST',
	// 				CURLOPT_POSTFIELDS => [
	// 						'video' => new CURLFile($file_tmp, mime_content_type($file_tmp), $file_name)
	// 				]
	// 			));
	// 			$response = curl_exec($curl);

	// 			curl_close($curl);
	// 			$response = json_decode($response, true);
	// 			if (isset($response['code'])) {
	// 				if ($response['code'] == 1) {
	// 					try {
	// 						$curl1 = curl_init();
	// 						curl_setopt_array($curl1, array(
	// 							CURLOPT_URL => 'https://' . Web_Zm_Url.Web_Path . 'index.php/ting?id=' . $response['did'],
	// 							CURLOPT_RETURNTRANSFER => true,
	// 							CURLOPT_ENCODING => '',
	// 							CURLOPT_MAXREDIRS => 10,
	// 							CURLOPT_TIMEOUT => 0,
	// 							CURLOPT_SSL_VERIFYHOST => 0,
	// 							CURLOPT_SSL_VERIFYPEER => 0,
	// 							CURLOPT_FOLLOWLOCATION => true,
	// 							CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	// 							CURLOPT_CUSTOMREQUEST => 'GET'
	// 						));
	// 						$response1 = curl_exec($curl1);
	// 						curl_close($curl1);
	// 						$response1 = json_decode($response1, true);
	// 					} catch (\Exeption $e) {

	// 					}
	// 					return $this->output
	// 					->set_content_type('application/json')
	// 					->set_status_header(200)
	// 					->set_output(json_encode([
	// 						'status' => 'success',
	// 						'msg' => $response['msg'],
	// 						'did' => $response['did']
	// 					]));
	// 				} else {
	// 					return $this->output
	// 					->set_content_type('application/json')
	// 					->set_status_header(200)
	// 					->set_output(json_encode([
	// 						'status' => 'error',
	// 						'msg' => $response['msg']
	// 					]));
	// 				}
	// 			} else {
	// 				return $this->output
	// 					->set_content_type('application/json')
	// 					->set_status_header(200)
	// 					->set_output(json_encode([
	// 						'status' => 'error',
	// 						'msg' => 'Error'
	// 					]));
	// 			}
	// 		} else {
	// 			return $this->output
	// 				->set_content_type('application/json')
	// 				->set_status_header(200)
	// 				->set_output(json_encode([
	// 					'status' => 'error',
	// 					'msg' => 'Error on uploaded file'
	// 				]));
	// 		}

			
			
	// 	} catch (\Exeption $e) {
	// 		return $this->output
	// 			->set_content_type('application/json')
	// 			->set_status_header(200)
	// 			->set_output(json_encode([
	// 				'status' => 'error',
	// 				'msg' => 'Some thing wrong: '
	// 			]));
	// 	}
		
	// }

	public function getserver()
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get('apikey'));
	
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$servers = $this->csdb->get_select('server','*',array('vip'=>$user->vip),'id ASC',100);
		$result = [];
		
		foreach ($servers as $server) {
			$result[] = [
				$server->id => $server->name
			];
		}

		
		return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'success',
				'msg' => '',
				'data' => $result
			]));
	}

	public function getvideoclass()
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get('apikey'));
	
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$classes = $this->csdb->get_select('class','*',array(),'id ASC',30);
		$result = [];
		
		foreach ($classes as $class) {
			$result[] = [
				$class->id => $class->name
			];
		}
		return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'success',
				'msg' => '',
				'data' => $result
			]));
	}

	public function getmyclass()
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get('apikey'));
	
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$myclass = $this->csdb->get_select('myclass','*',array('uid'=>$user->id,'fid'=>0),'id ASC',30);
		$result = [];
		
		foreach ($myclass as $class) {
			$result[] = [
				$class->id => $class->name
			];
		}
		return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'success',
				'msg' => '',
				'data' => $result
			]));
	}

	public function myvideo()
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get('apikey'));
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$page = $this->input->get_post('page') ?: 1;
		$per_page = $this->input->get_post('per_page') ?: 20;
		$search = $this->input->get_post('search') ?: '';
		$zt = $this->input->get_post('zt');
		$scid = (int)$this->input->get_post('cid');
		$smycid = (int)$this->input->get_post('mycid');
		$sfid = (int)$this->input->get_post('fid');
		$sField = $this->input->get_post('sort_field');
  		$sBy = $this->input->get_post('sort_by');

		$where = $like = array();
		$where['uid'] = $user->id;
		if (!is_null($zt)) {
			$where['zt'] = (int)$zt;
		}
		if($scid > 0) $where['cid'] = $scid;
		if($sfid > 0) $where['fid'] = $sfid;
		if($smycid > 0) $where['mycid'] = $smycid;


		if(empty($sField)) {
			$sField = 'id';
			$sBy = 'desc';
		}
		if (!empty($search)) {
			$like['name'] = $search;
		}

		$total = $this->csdb->get_nums('vod',$where,$like);
		$pagejs = ceil($total / $per_page); // Total pages
		if($pagejs == 0) $pagejs = 1;
		if($page > $pagejs) $page = $pagejs;
		$limit = array($per_page,$per_page*($page-1));

		$myvideos = $this->csdb->get_select('vod','*',$where, $sField . ' ' . $sBy, $limit,$like);

		$result = [];

		$classes = $this->csdb->get_select('class','*',array(),'id ASC');
		$cids = [];
		
		foreach ($classes as $class) {
			$cids[$class->id] = $class->name;
		}

		foreach ($myvideos as $myvideo) {
			if (array_key_exists($myvideo->cid, $cids)) {
				$cid = $cids[$myvideo->cid];
			} else {
				$cid = $myvideo->cid;
			}
			$result[] = [
					'id' => $myvideo->id,
					'vid' => $myvideo->vid,
					'name' => $myvideo->name,
					'cid' => $cid,
					'hits' => $myvideo->hits,
					'duration' => formattime($myvideo->duration,1),
					'size' => formatsize($myvideo->size),
					'uid' => $myvideo->uid,
					'addtime' => date('d-m-Y | H:i:s',$myvideo->addtime),
					'iframe' => '<iframe width="100%" height="100%" src="' . 'https://'.Web_Url.links('play','index',$myvideo->vid) . '" frameborder="0" allowfullscreen></iframe>',
					'link' => 'https://'.Web_Url.links('play','index',$myvideo->vid),
					'vip_iframe' => '<iframe width="100%" height="100%" src="' . 'https://'.Web_Url.links('vip','index',$myvideo->vid) . '" frameborder="0" allowfullscreen></iframe>',
					'vip_link' => 'https://'.Web_Url.links('vip','index',$myvideo->vid),
				];
			
		}

		return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'success',
				'msg' => '',
				'total_item' => (int)$total,
				'total_page' => (int)$pagejs,
				'current_page' => (int)$page,
				'count' => count($myvideos),
				'data' => $result
			]));
	}

	public function document()
	{
		$this->load->view('head.tpl');
        $this->load->view('api/document.tpl');
        $this->load->view('bottom.tpl');
		
	}

	public function getvideodetail($vid)
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get('apikey'));

		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$myvideo = $this->csdb->get_row('vod','*',array('uid'=>$user->id, 'vid' => safe_replace($vid)));

		if (!$myvideo) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Video not exist!'
			]));
		} else {
			$classes = $this->csdb->get_select('class','*',array(),'id ASC');
			$cids = [];
			
			foreach ($classes as $class) {
				$cids[$class->id] = $class->name;
			}
			if (array_key_exists($myvideo->cid, $cids)) {
				$cid = $cids[$myvideo->cid];
			} else {
				$cid = $myvideo->cid;
			}
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'success',
				'msg' => 'Success',
				'data' => [
					'id' => $myvideo->id,
					'vid' => $myvideo->vid,
					'name' => $myvideo->name,
					'cid' => $cid,
					'hits' => $myvideo->hits,
					'duration' => formattime($myvideo->duration,1),
					'size' => formatsize($myvideo->size),
					'uid' => $myvideo->uid,
					'addtime' => date('d-m-Y | H:i:s',$myvideo->addtime),
					'iframe' => '<iframe width="100%" height="100%" src="' . 'https://'.Web_Url.links('play','index',$myvideo->vid) . '" frameborder="0" allowfullscreen></iframe>',
					'link' => 'https://'.Web_Url.links('play','index',$myvideo->vid),
					'vip_iframe' => '<iframe width="100%" height="100%" src="' . 'https://'.Web_Url.links('vip','index',$myvideo->vid) . '" frameborder="0" allowfullscreen></iframe>',
					'vip_link' => 'https://'.Web_Url.links('vip','index',$myvideo->vid),
				]
			]));
		}
	}

	public function deletevideo($vid)
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get_post('apikey'));
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$myvideo = $this->csdb->get_row('vod','*',array('uid'=>$user->id, 'vid' => safe_replace($vid)));

		if (!$myvideo) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Video not exist!'
			]));
		} else {
			$res = $this->db->delete('vod',array('id'=>$myvideo->id));
			if ($res) {
				return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'success',
					'msg' => 'Deleted!'
				]));
			} else {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Error on deleted video'
					]));
			}
		}
	}

	public function updatevideo($vid)
	{
		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Method is not allowed!',
			]));
		}
		$apikey = trim($this->input->get_post('apikey'));
		if (empty($apikey)) {
			return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'apikey is required!'
				]));
		}
		
		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
		if (!$user) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(401)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Unauthorized!'
			]));
		}

		$myvideo = $this->csdb->get_row('vod','*',array('uid'=>$user->id, 'vid' => safe_replace($vid)));

		$name = $this->input->post('name');
		$cid = $this->input->post('cid');
		$mycid = $this->input->post('mycid');

		if ($name) {
			$edit['name'] = safe_replace($name);
		}

		if ($cid) {
			$videoclass = $this->csdb->get_row('class','*',array('id' => $cid));
			if (!$videoclass) {
				return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'cid is not correct!'
				]));
			}
			$edit['cid'] = $cid;
		}

		if ($mycid) {
			$myclass = $this->csdb->get_row('myclass','*',array('id' => $mycid,'uid' => $user->id, 'fid' => 0));
			if (!$myclass) {
				return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'mycid is not correct!'
				]));
			}
			$edit['mycid'] = $mycid;
		}

		try {
			if (!empty($edit)) {
				$this->csdb->get_update('vod',$myvideo->id,$edit);
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'success',
						'msg' => 'Updated!'
					]));
			} else {
				return $this->output
				->set_content_type('application/json')
				->set_status_header(200)
				->set_output(json_encode([
					'status' => 'error',
					'msg' => 'Nothing to update!'
				]));
			}
		} catch (\Exeption $e) {
			return $this->output
			->set_content_type('application/json')
			->set_status_header(200)
			->set_output(json_encode([
				'status' => 'error',
				'msg' => 'Error on update video!' . $e->getMessage()
			]));
		}
	}

	// public function uploadbyurl() {
// 		if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'Method is not allowed!',
// 			]));
// 		}
// 		$apikey = trim($this->input->get_post('apikey'));


// 		if (empty($apikey)) {
// 			return $this->output
// 				->set_content_type('application/json')
// 				->set_status_header(200)
// 				->set_output(json_encode([
// 					'status' => 'error',
// 					'msg' => 'apikey is required!'
// 				]));
// 		}
		
// 		$user = $this->csdb->get_row('user','*',array( 'apikey' => $apikey));
// 		if (!$user) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(401)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'Unauthorized!'
// 			]));
// 		}
// 		$videoUrl = $this->input->get_post('videoUrl');
// 		$cid = (int)$this->input->get_post('cid');
// 		$mycid = (int)$this->input->get_post('mycid');
// 		$fid = (int)$this->input->get_post('fid');

// 		if (empty($videoUrl)) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'videoUrl is required!'
// 			]));
// 		}

// 		if (empty($cid)) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'cid is required!'
// 			]));
// 		}
// 		if (empty($fid)) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'fid is required!'
// 			]));
// 		}

// 		$videoclass = $this->csdb->get_row('class','*',array('id' => $cid));
// 		if (!$videoclass) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'cid is not correct!'
// 			]));
// 		}

// 		if ($mycid) {
// 			$myclass = $this->csdb->get_row('myclass','*',array('id' => $mycid,'uid' => $user->id, 'fid' => 0));
// 			if (!$myclass) {
// 				return $this->output
// 				->set_content_type('application/json')
// 				->set_status_header(200)
// 				->set_output(json_encode([
// 					'status' => 'error',
// 					'msg' => 'mycid is not correct!'
// 				]));
// 			}
// 		} 
	
// 		$server = $this->csdb->get_row('server','*',array('id' => $fid,'vip' => $user->vip));
// 		if (!$server) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'fid is not correct!'
// 			]));
// 		}
// 		if ($server->zsize < $server->size) {
// 			return $this->output
// 			->set_content_type('application/json')
// 			->set_status_header(200)
// 			->set_output(json_encode([
// 				'status' => 'error',
// 				'msg' => 'The hard disk of this server is full, please choose another server'
// 			]));
// 		}

// 		$str['cid'] = $cid;
// 		$str['mycid'] = $mycid;
// 		$str['id'] = (string)$user->id;
// 		$str['vip'] = $user->vip;
// 		$str['login'] = md5($user->id . $user->name . $user->pass);
// 		$key = sys_auth(json_encode($str), 0, $server->apikey);
// 		$curl = curl_init();
// 		curl_setopt_array($curl, array(
// 			CURLOPT_URL => $server->apiurl . 'upload.php?key=' . $key,
// 			CURLOPT_RETURNTRANSFER => true,
// 			CURLOPT_ENCODING => '',
// 			CURLOPT_MAXREDIRS => 10,
// 			CURLOPT_TIMEOUT => 0,
// 			CURLOPT_SSL_VERIFYHOST => 0,
// 			CURLOPT_SSL_VERIFYPEER => 0,
// 			CURLOPT_FOLLOWLOCATION => true,
// 			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
// 			CURLOPT_CUSTOMREQUEST => 'POST',
// 			CURLOPT_POSTFIELDS => [
// 					'videoUrl' => $videoUrl
// 			]
// 		));
// 		$response = curl_exec($curl);

// 		curl_close($curl);
// 		$response = json_decode($response, true);
		
// 		if (isset($response['code'])) {
// 			if ($response['code'] == 1) {
// 				try {
// 					$curl1 = curl_init();
// 					curl_setopt_array($curl1, array(
// 						CURLOPT_URL => 'https://' . Web_Zm_Url.Web_Path . 'index.php/ting?id=' . $response['did'],
// 						CURLOPT_RETURNTRANSFER => true,
// 						CURLOPT_ENCODING => '',
// 						CURLOPT_MAXREDIRS => 10,
// 						CURLOPT_TIMEOUT => 0,
// 						CURLOPT_SSL_VERIFYHOST => 0,
// 						CURLOPT_SSL_VERIFYPEER => 0,
// 						CURLOPT_FOLLOWLOCATION => true,
// 						CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
// 						CURLOPT_CUSTOMREQUEST => 'GET'
// 					));
// 					$response1 = curl_exec($curl1);
// 					curl_close($curl1);
// 					$response1 = json_decode($response1, true);
// 				} catch (\Exeption $e) {

// 				}
// 				return $this->output
// 				->set_content_type('application/json')
// 				->set_status_header(200)
// 				->set_output(json_encode([
// 					'status' => 'success',
// 					'msg' => $response['msg'],
// 					'did' => $response['did']
// 				]));
// 			} else {
// 				return $this->output
// 				->set_content_type('application/json')
// 				->set_status_header(200)
// 				->set_output(json_encode([
// 					'status' => 'error',
// 					'msg' => $response['msg']
// 				]));
// 			}
// 		} else {
// 			return $this->output
// 				->set_content_type('application/json')
// 				->set_status_header(200)
// 				->set_output(json_encode([
// 					'status' => 'error',
// 					'msg' => 'Error'
// 				]));
// 		}

// 	}
// }