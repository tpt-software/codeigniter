<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Video extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('user');
        $this->load->helper('url');  // Đảm bảo helper này được load để sử dụng hàm site_url()
    }

    public function index($video_id=''){
        $subtitle_url = $this->input->get('subtitle_url', TRUE); // Nhận subtitle URL từ query string

        // Kiểm tra xem URL có hợp lệ không
        if (!filter_var($subtitle_url, FILTER_VALIDATE_URL)) {
            $subtitle_url = ''; // Nếu không hợp lệ, đặt là chuỗi rỗng
        }

        $data = [
            'video_id' => $video_id,
            'subtitle_url' => $subtitle_url
        ];

        $this->load->view('play', $data); // Chắc chắn rằng view này là 'play', không phải 'play.tpl' trừ khi bạn có cài đặt đặc biệt cho tpl
    }
}
