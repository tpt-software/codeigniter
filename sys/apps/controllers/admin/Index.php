<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Index extends CI_Controller {

	public function __construct(){
		parent::__construct();
		//Load member model
		$this->load->model('admin');
        //Judgment login
		$this->admin->login();
        //Current template
		$this->load->get_templates();
	}

	//Admin Home
    public function index() {
    	$id = (int)$this->cookie->get('admin_id');
		$admin = $this->csdb->get_row('admin','*',array('id'=>$id));
		$data['title'] = 'Admin home - '.Web_Name;
		$data['admin'] = $admin;

		$header = $this->load->view('header.tpl', '', true);
		$leftsidebar = $this->load->view('leftsidebar.tpl', '', true);
		$data['header'] = $header;
		$data['leftsidebar'] = $leftsidebar;

        $this->load->view('index.tpl',$data);
	}

    public function main() {
    	$data['logip'] = $this->cookie->get('admin_logip');
    	$data['admin'] = $this->cookie->get('admin_nichen');
    	$data['logtime'] = $this->cookie->get('admin_logtime');
    	//Video statistics
    	$jtime = strtotime(date('Y-m-d'))-1;
    	$data['jcount'] = $this->csdb->get_nums('vod',array('addtime>'=>$jtime));
    	//Yesterday
    	$jtime = strtotime(date('Y-m-d'));
    	$ztime = strtotime(date('Y-m-d'))-86401;
    	$data['zcount'] = $this->csdb->get_nums('vod',array('addtime>'=>$ztime,'addtime<'=>$jtime));
    	//This month
    	$jtime = strtotime(date('Y-m-1'))-1;
    	$data['bcount'] = $this->csdb->get_nums('vod',array('addtime>'=>$jtime));
    	//Last month
    	$time = strtotime('-1 month');
    	$jtime = strtotime(date('Y-m-1',$time));
    	$ztime = strtotime(date('Y-m-1'));
    	$data['scount'] = $this->csdb->get_nums('vod',array('addtime>'=>$ztime,'addtime<'=>$jtime));
    	//Total
    	$data['count'] = $this->csdb->get_nums('vod');
    	//To be transcoded
    	$data['dzcount'] = $this->csdb->get_nums('vod',array('zt'=>0, 'is_remote_m3u8' => 0));
		$data['fzcount'] = $this->csdb->get_nums('vod',array('zt'=>3));
        $this->load->view('main.tpl',$data);
	}
}

