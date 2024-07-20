<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Setting extends CI_Controller {
	function __construct(){
	    parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}
	//Modify system configuration
	public function index(){	
		//Subtitle content
		$str = file_get_contents(FCPATH.'packs/ffmpeg/zimu.ass');
		$arr = explode('[Events]', $str);
		$zimu = isset($arr[1]) ? $arr[1] : '';
		$data['zimu'] = str_replace("\r\n","",str_replace('{\b0}{\fs}{\fn}','',$zimu));

		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;
		
		$this->load->view('setting.tpl',$data);
	}
	public function save(){
		// New variable added
		$Is_OTP = $this->input->get_post('is_otp_admin',true);

		//Basic settings
		$Web_Name = $this->input->get_post('Web_Name',true);
		$Web_Path = $this->input->get_post('Web_Path',true);
		$Web_Url = $this->input->get_post('Web_Url',true);
		$Web_Zm_Url = $this->input->get_post('Web_Zm_Url',true);
		$Web_M3u8_Url = $this->input->get_post('Web_M3u8_Url',true);
		$Web_Pic_Url = $this->input->get_post('Web_Pic_Url',true);
		$Web_Reg = (int)$this->input->get_post('Web_Reg',true);
		$Web_Gg = str_encode($this->input->get_post('Web_Gg'));

		$Web_Url = str_replace(array('http://','/'),'',$Web_Url);
		$Web_Zm_Url = str_replace(array('http://','/'),'',$Web_Zm_Url);
		$Web_M3u8_Url = str_replace(array('http://','/'),'',$Web_M3u8_Url);
		$Web_Pic_Url = str_replace(array('http://','/'),'',$Web_Pic_Url);

		//Screenshot animation
		$Jpg_On = intval($this->input->get_post('Jpg_On',true));
		$Jpg_Num = intval($this->input->get_post('Jpg_Num',true));
		$Jpg_Time = intval($this->input->get_post('Jpg_Time',true));
		$Jpg_Size = $this->input->get_post('Jpg_Size',true);
		if($Jpg_Num == 0) $Jpg_Num = 1;
		if($Jpg_Num > 20) getjson('Sorry, the maximum number of screenshots is 20');
		if($Jpg_On==0){
			$jpgarr = explode('x', $Jpg_Size);
			if(!empty($Jpg_Size) && (sizeof($jpgarr)!=2 || intval($jpgarr[0])<1 || intval($jpgarr[1])<1)){
				getjson('The screenshot size format is incorrect');
			}
		}
		//Transcoding settings
		$Zm_Time = intval($this->input->get_post('Zm_Time',true));
		$Zm_Size = $this->input->get_post('Zm_Size',true);
		$Zm_Dir = $this->input->get_post('Zm_Dir',true);
		$Zm_Kbps = (int)$this->input->get_post('Zm_Kbps',true);
		$Zm_Preset = $this->input->get_post('Zm_Preset',true);
		if($Zm_Kbps == 0) getjson('The bitrate format of the slice is incorrect');

		if(empty($Zm_Dir)) getjson('The slice directory cannot be left empty');
		$muarr = explode('x', $Zm_Size);
		if(!empty($Zm_Size) && (sizeof($muarr)!=2 || intval($muarr[0])<1 || intval($muarr[1])<1)){
			getjson('Sliced video dimensions are not in the correct format');
		}

		$Zm_Sy = intval($this->input->get_post('Zm_Sy',true));
		$Zm_Sylt = $this->input->get_post('Zm_Sylt',true);
		$Zm_Zm = intval($this->input->get_post('Zm_Zm',true));
		$Zm_Zmtxt = $this->input->get_post('Zm_Zmtxt');
		if($Zm_Zm == 1){
			if(empty($Zm_Zmtxt)) getjson('Subtitle content cannot be empty');
		}
		if(substr($Zm_Zmtxt,0,9) != 'Dialogue:'){
			getjson('Wrong subtitle content format');
		}
		//Modify subtitle content
		$zmstr = file_get_contents(FCPATH.'packs/ffmpeg/zimu.ass');
		$zmarr = explode("[Events]\r\n", $zmstr);
		$yzimu = isset($zmarr[1]) ? $zmarr[1] : '';
		$zmarr = explode('Dialogue:',$Zm_Zmtxt);
		unset($zmarr[0]);
		$Zm_Zmtxt = "Dialogue:".implode("\r\n{\\b0}{\\fs}{\\fn}\r\nDialogue:",$zmarr);
		$zimu = current(explode('[Events]', $zmstr))."[Events]\r\n".$Zm_Zmtxt;
		write_file(FCPATH.'packs/ffmpeg/zimu.ass', $zimu);

		if($Zm_Sy == 1){
			$wmarr = explode(':', $Zm_Sylt);
			if(sizeof($wmarr)<2) getjson('Watermark spacing format is incorrect');
			$Zm_Sylt = intval($wmarr[0]).':'.intval($wmarr[1]);
		}

		$Up_Dir = $this->input->get_post('Up_Dir',true);
		$Up_Ext = $this->input->get_post('Up_Ext',true);
		if(empty($Up_Dir)) getjson('The upload path cannot be empty');
		if(empty($Up_Ext)) getjson('Supported upload formats cannot be empty');

		$Del_Mp4 = (int)$this->input->get_post('Del_Mp4',true);
		$Del_M3u8 = (int)$this->input->get_post('Del_M3u8',true);

		$Admin_QQ = $this->input->get_post('Admin_QQ',true);
		$Admin_Qun = $this->input->get_post('Admin_Qun',true);
		$Admin_Count = str_encode($this->input->get_post('Admin_Count'));
      
		$Tb_Zt = (int)$this->input->get_post('Tb_Zt',true);
		$Tb_Url = $this->input->get_post('Tb_Url',true);
		$Tb_Key = $this->input->get_post('Tb_Key',true);


		//Configuration string
		$strs = "<?php"."\r\n";
        $strs .= "define('Web_Name','".$Web_Name."'); //Site name\r\n";
        $strs .= "define('Web_Url','".$Web_Url."'); //Domain name\r\n";
        $strs .= "define('Web_Zm_Url','".$Web_Zm_Url."'); //Transcoding domain name\r\n";
        $strs .= "define('Web_M3u8_Url','".$Web_M3u8_Url."'); //M3u8 domain name\r\n";
        $strs .= "define('Web_Pic_Url','".$Web_Pic_Url."'); //Image domain name\r\n";
        $strs .= "define('Web_Path','".$Web_Path."'); //Site path\r\n";
        $strs .= "define('Web_Reg',".$Web_Reg.");  //Member registration status, 0 review, 1 pending review\r\n";
        $strs .= "define('Web_Gg','".$Web_Gg."');  //Website Announcement\r\n";

        $strs .= "define('Up_Dir','".$Up_Dir."'); //Upload source file save path\r\n";
        $strs .= "define('Up_Ext','".$Up_Ext."'); //Supported upload formats\r\n";

        $strs .= "define('Del_Mp4',".$Del_Mp4."); //Whether to delete the source file of the deleted video\r\n";
        $strs .= "define('Del_M3u8',".$Del_M3u8."); //Whether to delete the slice resource when deleting the video\r\n";

        $strs .= "define('Zm_Dir','".$Zm_Dir."');  //Slice save directory\r\n";
        $strs .= "define('Zm_Preset','".$Zm_Preset."'); //Slice priority\r\n";
        $strs .= "define('Zm_Time',".$Zm_Time.");  //Duration seconds per TS\r\n";
        $strs .= "define('Zm_Kbps','".$Zm_Kbps."k');  //Slice rate\r\n";
        $strs .= "define('Zm_Size','".$Zm_Size."');  //Slice size\r\n";
        $strs .= "define('Zm_Zm',".$Zm_Zm.");  //Whether to enable subtitles. 0 off, 1 on\r\n";
        $strs .= "define('Zm_Sy',".$Zm_Sy.");  //Watermark switch, 0 off, 1 upper left, 2 upper right, 3 lower left, 4 lower right\r\n";
        $strs .= "define('Zm_Sylt','".$Zm_Sylt."');  //Upper left distance border position\r\n";

        $strs .= "define('Jpg_On',".$Jpg_On.");  //Screenshot switch, 1 is on and 0 is off\r\n";
        $strs .= "define('Jpg_Num',".$Jpg_Num.");  //Number of screenshots\r\n";
        $strs .= "define('Jpg_Time',".$Jpg_Time.");  //Interval seconds\r\n";
        $strs .= "define('Jpg_Size','".$Jpg_Size."');  //Screenshot size\r\n";

        $strs .= "define('Admin_Count','".$Admin_Count."'); //Statistical code\r\n";
      
        $strs .= "define('Tb_Zt',".$Tb_Zt."); //Sync status\r\n";
        $strs .= "define('Tb_Url','".$Tb_Url."'); //Sync address\r\n";
        $strs .= "define('Tb_Key','".$Tb_Key."'); //Sync key\r\n";
        $strs .= "define('Is_OTP','".$Is_OTP."'); //Sync key";

		//Perform sync to remote server
		if($Web_Url != Web_Url || 
			$Up_Ext != Up_Ext || 
			$Zm_Preset != Zm_Preset || 
			$Zm_Time != Zm_Time || 
			$Zm_Kbps != Zm_Kbps || 
			$Zm_Size != Zm_Size || 
			$Zm_Zm != Zm_Zm || 
			$Zm_Sy != Zm_Sy || 
			$Zm_Sylt != Zm_Sylt || 
			$Jpg_On != Jpg_On || 
			$Jpg_Num != Jpg_Num || 
			$Jpg_Time != Jpg_Time || 
			$Jpg_Size != Jpg_Size || 
			$Is_OTP != Is_OTP || 
			$yzimu != $Zm_Zmtxt
		){
			if($yzimu != $Zm_Zmtxt) $post['zmtxt'] = $Zm_Zmtxt;
			$server = $this->csdb->get_select('server','id,vip,apiurl,apikey,mp4dir,m3u8dir',array(),'id DESC',50);
			foreach($server as $row){
				$post['Web_ID'] = $row->id;
				$post['Web_Url'] = 'http://'.Web_Url.Web_Path;
				$post['Up_Dir'] = $row->mp4dir;
				$post['Up_Ext'] = $Up_Ext;
				$post['Zm_Dir'] = $row->m3u8dir;
				$post['Zm_Preset'] = $Zm_Preset;
				$post['Zm_Time'] = $Zm_Time;
				$post['Zm_Kbps'] = $Zm_Kbps;
				$post['Zm_Size'] = $Zm_Size;
				$post['Zm_Zm'] = $Zm_Zm;
				$post['Zm_Sy'] = $Zm_Sy;
				$post['Zm_Sylt'] = $Zm_Sylt;
				$post['Jpg_On'] = $Jpg_On;
				$post['Jpg_Num'] = $Jpg_Num;
				$post['Jpg_Time'] = $Jpg_Time;
				$post['Jpg_Size'] = $Jpg_Size;
				$post['Is_OTP'] = $Is_OTP;
				$post['Api_Key'] = $row->apikey;
				$apiurl = $row->apiurl.'api.php?ac=set&key='.$row->apikey;
				$res = geturl($apiurl,$post);
			}
		}

        //Write file
        if (!write_file(FCPATH.'sys/libs/config.php', $strs)){
            getjson('Sorry, the sys/libs/config.php file does not have permission to modify');
        }else{
        	$info['url'] = site_url('setting').'?v='.rand(1000,1999);
            $info['msg'] = 'Congratulations, the modification is successful';
        	getjson($info,1);
        }
	}
}
