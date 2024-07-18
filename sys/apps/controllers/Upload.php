<?php
defined('BASEPATH') or exit('No direct script access allowed');
class Upload extends CI_Controller
{
	function __construct()
	{
		parent::__construct();
		//Load member model
		$this->load->model('user');
		//Current template
		$this->load->get_templates();
	}

	public function loadurl()
	{
		$this->user->login();
		$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));
		$cid = (int) $this->input->get_post('cid');
		$mycid = (int) $this->input->get_post('mycid');
		$fid = (int) $this->input->get_post('fid');
		$apikey = '';
		if ($fid > 0) {
			$rows = $this->csdb->get_row('server', '*', array('id' => $fid));
			if (!$rows)
				exit('The server does not exist~');
			if ($rows->zsize < $rows->size)
				exit('The hard disk of this server is full, please choose another server');
			if ($user->vip == 0 && $rows->vip == 1)
				exit('This line is exclusive for VIP, please choose another line');
			$data['saveurl'] = $rows->apiurl . 'upload.php';

			// $data['saveurl'] = 'https://vip.14412882.local/upload.php';

			$apikey = $rows->apikey;
			// TODO test
			// $apikey = '4didhtky38zif732hj7z2symin24dy6i';
		} else {
			$data['saveurl'] = links('upload', 'save');
		}
		$data['title'] = 'Upload video - ' . Web_Name;
		$data['class'] = $this->csdb->get_select('class', '*', array(), 'id ASC', 30);
		$data['myclass'] = $this->csdb->get_select('myclass', '*', array('uid' => $user->id, 'fid' => 0), 'id ASC', 10000);
		$data['server'] = $this->csdb->get_select('server', '*', array('vip' => $user->vip), 'id ASC', 100);
		$data['user'] = $user;
		$row = $this->csdb->get_row('myclass', 'id', array('id' => $mycid, 'uid' => $this->cookie->get('user_id')));
		if (!$row)
			$mycid = 0;
		$row = $this->csdb->get_row('class', 'id', array('id' => $cid));
		if (!$row)
			$cid = 0;
		$data['cid'] = $cid;
		$data['fid'] = $fid;
		$data['mycid'] = $mycid;

		$str['cid'] = $cid;
		$str['mycid'] = $mycid;
		$str['id'] = $this->cookie->get('user_id');
		$str['vip'] = $user->vip;
		$str['login'] = md5($user->id . $user->name . $user->pass);
		$key = sys_auth(json_encode($str), 0, $apikey);
		$data['key'] = $key;

		$this->load->view('head.tpl', $data);
		$this->load->view('upload_url.tpl');
		$this->load->view('bottom.tpl');
	}

	public function index()
	{
		//Judgment login
		$this->user->login();
		$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));
		$cid = (int) $this->input->get_post('cid');
		$mycid = (int) $this->input->get_post('mycid');
		$fid = (int) $this->input->get_post('fid');
		$apikey = '';
		if ($fid > 0) {
			$rows = $this->csdb->get_row('server', '*', array('id' => $fid));
			if (!$rows)
				exit('The server does not exist~');
			if ($rows->zsize < $rows->size)
				exit('The hard disk of this server is full, please choose another server');
			if ($user->vip == 0 && $rows->vip == 1)
				exit('This line is exclusive for VIP, please choose another line');

			$data['saveurl'] = $rows->apiurl . 'upload.php';

			$apikey = $rows->apikey;
		} else {
			$data['saveurl'] = links('upload', 'save');
		}
		$data['title'] = 'Upload video - ' . Web_Name;
		$data['class'] = $this->csdb->get_select('class', '*', array(), 'id ASC', 30);
		$data['myclass'] = $this->csdb->get_select('myclass', '*', array('uid' => $user->id, 'fid' => 0), 'id ASC', 10000);
		$data['server'] = $this->csdb->get_select('server', '*', array('vip' => $user->vip), 'id ASC', 100);
		$data['user'] = $user;
		$row = $this->csdb->get_row('myclass', 'id', array('id' => $mycid, 'uid' => $this->cookie->get('user_id')));
		if (!$row)
			$mycid = 0;
		$row = $this->csdb->get_row('class', 'id', array('id' => $cid));
		if (!$row)
			$cid = 0;
		$data['cid'] = $cid;
		$data['fid'] = $fid;
		$data['mycid'] = $mycid;

		$str['cid'] = $cid;
		$str['mycid'] = $mycid;
		$str['id'] = $this->cookie->get('user_id');
		$str['vip'] = $user->vip;
		$str['login'] = md5($user->id . $user->name . $user->pass);
		$key = sys_auth(json_encode($str), 0, $apikey);

		$data['key'] = $key;
		$this->load->view('head.tpl', $data);
		$this->load->view('upload.tpl');
		$this->load->view('bottom.tpl');
	}


	function m3u8()
	{
		// get = load page
		if ($_SERVER['REQUEST_METHOD'] == 'GET') {
			$this->user->login();
			$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));
			$data['title'] = 'Upload video by m3u8 - ' . Web_Name;
			$data['class'] = $this->csdb->get_select('class', '*', array(), 'id ASC', 30);
			$data['myclass'] = $this->csdb->get_select('myclass', '*', array('uid' => $user->id, 'fid' => 0), 'id ASC', 10000);
			$data['server'] = $this->csdb->get_select('server', '*', array('vip' => $user->vip), 'id ASC', 100);
			$data['user'] = $user;

			$this->load->view('head.tpl', $data);
			$this->load->view('upload_m3u8.tpl');
			$this->load->view('bottom.tpl');

		} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') { // post = save 
			$this->user->login();
			$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));

			$result = ['status' => 'error', 'msg' => ''];

			$thumnail_url = $this->input->get_post('thumnail_url', '');
			$name = $this->input->get_post('name', '');
			$cid = $this->input->get_post('cid');
			$mycid = $this->input->get_post('mycid');
			$fid = 0;
			$m3u8_url = $this->input->get_post('m3u8_url');

			// validate name
			if (empty($name)) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Video name is required!'
					]));
			}

			// validate $cid
			if (empty($cid)) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Video classification is required!'
					]));
			}
			$videoclass = $this->csdb->get_row('class', '*', array('id' => $cid));
			if (!$videoclass) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Video classification is not correct!'
					]));
			}

			//validate mycid
			if ($mycid) {
				$myclass = $this->csdb->get_row('myclass', '*', array('id' => $mycid, 'uid' => $user->id, 'fid' => 0));
				if (!$myclass) {
					return $this->output
						->set_content_type('application/json')
						->set_status_header(200)
						->set_output(json_encode([
							'status' => 'error',
							'msg' => 'Private classification  is not correct!'
						]));
				}
			}
			// validate thumb image url 
			if (!empty($thumbUrl) && (filter_var($thumbUrl, FILTER_VALIDATE_URL) === false || preg_match('/^https?:\/\/\S+$/', $thumbUrl) != 1)) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Thumnail image url is not correct'
					]));
			}

			//validate m3u8 url
			if (filter_var($m3u8_url, FILTER_VALIDATE_URL) === false || preg_match('/^https?:\/\/\S+$/', $m3u8_url) != 1) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'M3u8 url is not correct'
					]));
			}

			$m3u8Arr = parse_url($m3u8_url);
			if (!isset($m3u8Arr['path'])) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'M3u8 url is not correct'
					]));
			}
			$pathArr = explode('/', $m3u8Arr['path']);
			if (!isset($pathArr[count($pathArr) - 1]) || preg_match('/\w+\.m3u8/', $pathArr[count($pathArr) - 1]) != 1) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'M3u8 url is not correct'
					]));
			}

			$vid = explode('.', $pathArr[count($pathArr) - 1])[0];
			$row = $this->csdb->get_row('vod', '*', array('vid' => $vid));
			if ($row) {
				$vid = $vid . get_vid(rand(1111, 9999));
			}
			$add = [
				'vid' => $vid,
				'vip' => $user->vip,
				'name' => $name,
				'cid' => $cid,
				'mycid' => (int) $mycid,
				'uid' => $user->id,
				'fid' => $fid,
				'zt' => 2,//transcoded
				'addtime' => time(),
				'is_remote_m3u8' => 1,
				'thumnail_url' => $thumnail_url,
				'm3u8_url' => $m3u8_url,
			];

			$did = $this->csdb->get_insert("vod", $add);

			if ($did) {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'success',
						'msg' => 'Success',
						'did' => $did
					]));
			} else {
				return $this->output
					->set_content_type('application/json')
					->set_status_header(200)
					->set_output(json_encode([
						'status' => 'error',
						'msg' => 'Can not save vod'
					]));
			}


		}

	}

	public function save($cid = 0, $mycid = 0)
	{
		getjson('Please select an upload server!!!');
		set_time_limit(0);
		$key = $this->input->get_post('key');
		$login = $this->user->login(1, $key);
		if (!$login)
			getjson('Login timed out, please log in again');
		$arr = json_decode(sys_auth($key, 1), 1);
		$add['uid'] = $arr['id'];
		$add['cid'] = $arr['cid'];
		$add['mycid'] = $arr['mycid'];

		if (substr(Up_Dir, 0, 2) == './') {
			$Video_Path = FCPATH . substr(Up_Dir, 2);
		} else {
			$Video_Path = Up_Dir;
		}

		//Shard folder
		$targetDir = $Video_Path . '/temp/' . date('Ymd') . '/';
		//Save the drive letter path
		$uploadDir = $Video_Path . '/' . date('Ym') . '/';
		$uploadStr = date('Ym') . '/';
		//Defines the file extensions that are allowed to be uploaded
		$ext_arr = array_filter(explode('|', Up_Ext));
		//Prevent external cross-site submissions
		if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
			getjson('Incorrect submission method');
		}
		//Upload error
		if (!empty($_REQUEST['debug'])) {
			$random = rand(0, intval($_REQUEST['debug']));
			if ($random === 0) {
				getjson($_REQUEST['debug']);
			}
		}
		//Create a directory
		if (!file_exists($targetDir)) {
			mkdirss($targetDir);
		}
		//Create a directory
		if (!file_exists($uploadDir)) {
			mkdirss($uploadDir);
		}
		//Original file name
		if (!isset($_FILES['video']['name'])) {
			getjson('No FILES');
		}
		$file_name = $_FILES['video']['name'];
		//File extension
		$file_ext = strtolower(trim(substr(strrchr($file_name, '.'), 1)));
		$newname = iconv("UTF-8", "GBK//IGNORE", $file_name);
		$video_name = safe_replace(str_replace('.' . $file_ext, '', $file_name));
		//Determine the file suffix
		if (in_array($file_ext, $ext_arr) === false)
			getjson("Unsupported video format");
		//Check if the song exists
		$res = $this->csdb->get_row('vod', 'id', array('name' => $video_name, 'uid' => $add['uid']));
		if ($res)
			getjson("The video already exists, no need to upload it again");
		//Generate a unique MD5 based on the file name and member ID
		$fileName = md5($file_name . $add['uid']) . '.' . $file_ext;
		$oldName = $fileName;
		$filePath = $targetDir . DIRECTORY_SEPARATOR . $fileName;
		//Fragment ID
		$chunk = isset($_REQUEST["chunk"]) ? intval($_REQUEST["chunk"]) : 0;
		//Total number of shards
		$chunks = isset($_REQUEST["chunks"]) ? intval($_REQUEST["chunks"]) : 1;
		//Open temporary file 
		if (!$out = @fopen("{$filePath}_{$chunk}.parttmp", "wb")) {
			getjson('Failed to open output stream.');
		}
		if (!empty($_FILES)) {

			if ($_FILES["video"]["error"] || !is_uploaded_file($_FILES["video"]["tmp_name"])) {
				getjson('Failed to move uploaded file.');
			}
			//Read a binary input stream and append it to a temporary file
			if (!$in = @fopen($_FILES["video"]["tmp_name"], "rb")) {
				getjson('Failed to open input stream.');
			}
		} else {
			if (!$in = @fopen("php://input", "rb")) {
				getjson('Failed to open input stream.');
			}
		}
		while ($buff = fread($in, 4096)) {
			fwrite($out, $buff);
		}
		@fclose($out);
		@fclose($in);
		rename("{$filePath}_{$chunk}.parttmp", "{$filePath}_{$chunk}.part");
		$index = 0;
		$done = true;
		for ($index = 0; $index < $chunks; $index++) {
			if (!file_exists("{$filePath}_{$index}.part")) {
				$done = false;
				break;
			}
		}
		if ($done) {
			$pathInfo = pathinfo($fileName);
			$hashStr = substr(md5($pathInfo['basename']), 8, 5);
			$hashName = date('YmdHis') . $hashStr . '.' . $pathInfo['extension'];
			$uploadPath = $uploadDir . $hashName;
			if (!$out = @fopen($uploadPath, "wb")) {
				getjson('Failed to open output stream.');
			}
			if (flock($out, LOCK_EX)) {
				for ($index = 0; $index < $chunks; $index++) {
					if (!$in = @fopen("{$filePath}_{$index}.part", "rb")) {
						break;
					}
					while ($buff = fread($in, 4096)) {
						fwrite($out, $buff);
					}
					@fclose($in);
					@unlink("{$filePath}_{$index}.part");
				}
				flock($out, LOCK_UN);
			}
			@fclose($out);
			//video
			$add['name'] = $video_name;
			$add['filepath'] = $uploadPath;
			$add['addtime'] = time();
			$this->load->library('ffmpeg');
			$format = $this->ffmpeg->format($uploadPath);
			if (empty($format['size']) || empty($format['duration'])) {
				unlink($uploadPath);
				getjson('ffmpeg error');
			}
			$add['duration'] = $format['duration'];
			$add['size'] = $format['size'];
			$add['vid'] = get_vid(rand(1111, 9999));
			$did = $this->csdb->get_insert("vod", $add);
			//Return data
			$ok['msg'] = 'Video upload complete';
			$ok['did'] = $did;
			getjson($ok, 1);
		}
	}

	public function getkey()
	{
		$this->user->login();
		$user = $this->csdb->get_row('user', '*', array('id' => $this->cookie->get('user_id')));

		$cid = (int) $this->input->get_post('cid');
		$mycid = (int) $this->input->get_post('mycid');
		$fid = (int) $this->input->get_post('fid');
		$apikey = '';
		if ($fid > 0) {
			$rows = $this->csdb->get_row('server', '*', array('id' => $fid));
			if (!$rows)
				exit('The server does not exist~');
			if ($rows->zsize < $rows->size)
				exit('The hard disk of this server is full, please choose another server');
			if ($user->vip == 0 && $rows->vip == 1)
				exit('This line is exclusive for VIP, please choose another line');
			$apikey = $rows->apikey;
		}

		$str['cid'] = $cid;
		$str['mycid'] = $mycid;
		$str['id'] = $this->cookie->get('user_id');
		$str['vip'] = $user->vip;
		$str['login'] = md5($user->id . $user->name . $user->pass);
		$key = sys_auth(json_encode($str), 0, $apikey);
		$ok = ['status' => 'success', 'data' => $key];
		getjson($ok, 1);
	}
}