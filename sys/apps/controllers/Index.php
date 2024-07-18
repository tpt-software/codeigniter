<?php
// File: application/controllers/Index.php

defined('BASEPATH') OR exit('No direct script access allowed');

class Index extends CI_Controller {

    public function __construct(){
        parent::__construct();
        //Current template
        $this->load->get_templates();
    }

    public function index(){
        header("location:".links('index.html'));
        exit;
    }

    public function webhook(){
        // Điều gì đó liên quan đến PayPal Webhook
        // Ví dụ: load view, xử lý sự kiện từ PayPal Webhook, ...
    }
}
