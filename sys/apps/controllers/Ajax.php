<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Ajax extends CI_Controller
{
    function __construct()
    {
        parent::__construct();
        // Load member model
        $this->load->model('user');
    }

    // Favorite video
    public function fav($id = 0)
    {
        $id = (int) $id;
        if ($id == 0)
            getjson('Video ID cannot be empty');
        if (!$this->user->login(1))
            getjson('Login timed out, please log in first');
        $row = $this->csdb->get_row('vod', 'cid', array('id' => $id));
        if (!$row)
            getjson('Video does not exist');
        $row2 = $this->csdb->get_row('fav', 'id', array('did' => $id, 'uid' => $this->cookie->get('user_id')));
        if ($row2)
            getjson('This video has already been favorited');

        $add['did'] = $id;
        $add['cid'] = $row->cid;
        $add['uid'] = $this->cookie->get('user_id');
        $add['addtime'] = time();
        $this->csdb->get_insert('fav', $add);
        getjson('Video collection successful', 1);
    }

    // Delete favorite
    public function delfav($id = 0)
    {
        $id = (int) $id;
        if ($id == 0)
            getjson('Video ID cannot be empty');
        if (!$this->user->login(1))
            getjson('Login timed out, please log in first');
        $row2 = $this->csdb->get_row('fav', 'id', array('id' => $id, 'uid' => $this->cookie->get('user_id')));
        if (!$row2)
            getjson('The record does not exist');
        $this->db->delete('fav', array('id' => $id));
        getjson('Cancel favorite successfully', 1);
    }

    // Abnormal video transcoding
    public function err()
    {
        // Transcoding not complete
        $time = time() - 300;
        $res = $this->csdb->get_select('vod', '*', array('zt' => 1, 'zmtime<' => $time), 'id ASC', 100);

        foreach ($res as $row) {
            $zt = 3;
            if ($row->fid > 0) {
                $post['vid'] = $row->vid;
                $post['addtime'] = $row->addtime;
                $apikey = getzd('server', 'apikey', $row->fid);
                $row2 = $this->csdb->get_row_arr('server', '*', array('id' => $row->fid));
                $apiurl = $row2['apiurl'] . 'api.php?ac=init&key=' . $row2['apikey'];
                $zt = (int) geturl($apiurl, $post);
                if ($zt == 0)
                    $zt = 1;
            } else {
                $row2 = array();
                $m3u8file = m3u8_dir($row->vid, $row->addtime) . 'playlist.m3u8';
                if (file_exists($m3u8file)) {
                    $m3u8 = file_get_contents($m3u8file);
                    if (strpos($m3u8, '#EXT-X-ENDLIST') !== false) {
                        $zt = 2;
                    } else {
                        $zt = 1;
                    }
                }
            }
            // Perform synchronization
            if ($zt == 2 && Tb_Zt == 1 && !empty(Tb_Url) && !empty(Tb_Key)) {
                $tb['name'] = $row->name;
                $tb['cid'] = $row->cid;
                $tb['pic'] = m3u8_link($row->vid, $row->addtime, 'pic', 1, $row2);
                $tb['m3u8url'] = m3u8_link($row->vid, $row->addtime, 'm3u8', 1, $row2);
                $tb['shareurl'] = 'http://' . Web_Url . links('play', 'index', $row->vid);
                $tb['token'] = Tb_Key;
                $res = geturl(Tb_Url, $tb);
                get_log(date('Y-m-d H:i:s') . '：Video：' . $row->name . '--->Synchronous commit--->State：' . $res);
            }

            $this->csdb->get_update('vod', $row->id, array('zt' => $zt));
        }

    }

    // Execute untranscoded video
    public function zm()
    {
        $res1 = $this->csdb->get_select('server', 'id', array(), 'id ASC', 50);
        foreach ($res1 as $row2) {
            $res2 = $this->csdb->get_select('vod', 'id', array('zt' => 0, 'fid' => $row2->id), 'id ASC', 10);
            foreach ($res2 as $row) {
                $zmurl = 'http://' . Web_Zm_Url . Web_Path . 'index.php/ting?id=' . $row->id;
                $res3 = file_get_contents($zmurl);
            }
        }
    }

    // API
    public function api($ac)
    {
        // New record
        if ($ac == 'add') {
            $key = $this->input->get_post('key', true);
            $fid = (int) $this->input->get_post('fid', true);
            // Judgment key
            $row = $this->csdb->get_row('server', 'size,apikey', array('id' => $fid));

            if (!$row || $row->apikey != $key) {
                exit('0');
            }
            ;

            unset($_GET['key']);
            $name = $this->input->get_post('name', true);
            $uid = (int) $this->input->get_post('uid', true);
            // Determine if the video has been uploaded
            $res = $this->csdb->get_row('vod', 'id', array('name' => $name, 'uid' => $uid));
            if ($res)
                exit('yes');
            // Storage
            $did = $this->csdb->get_insert("vod", $_GET);
            if ($did) {
                // Modify capacity
                $this->csdb->get_update('server', $fid, array('size' => ($row->size + $_GET['size'])));
            }

            echo $did;

        } elseif ($ac == 'zm') { // Transcoding status
            $key = $this->input->get_post('key', true);
            $id = (int) $this->input->get_post('id', true);
            $zt = (int) $this->input->get_post('zt', true);
            if ($zt > 3)
                $zt = 3;
            if ($id > 0) {
                $row = $this->csdb->get_row('vod', 'id,vid,cid,fid,name,addtime', array('id' => $id));
                $rows = $this->csdb->get_row_arr('server', '*', array('id' => $row->fid));
                if (!$rows || $rows['apikey'] != $key)
                    exit('0');
                if ($zt == 2) {
                    get_log(date('Y-m-d H:i:s') . '：Video：' . $row->name . '--->Transcoding complete');
                    // Perform synchronization
                    if (Tb_Zt == 1 && !empty(Tb_Url) && !empty(Tb_Key)) {
                        $tb['name'] = $row->name;
                        $tb['cid'] = $row->cid;
                        $tb['pic'] = m3u8_link($row->vid, $row->addtime, 'pic', 1, $rows);
                        $tb['m3u8url'] = m3u8_link($row->vid, $row->addtime, 'm3u8', 1, $rows);
                        $tb['shareurl'] = 'http://' . Web_Url . links('play', 'index', $row->vid);
                        $tb['token'] = Tb_Key;
                        $res = geturl(Tb_Url, $tb);
                        get_log(date('Y-m-d H:i:s') . '：Video：' . $row->name . '--->Synchronous commit--->State：' . $res);
                    }
                } else {
                    get_log(date('Y-m-d H:i:s') . '：Video：' . $row->name . '--->Transcoding failed');
                }
                $this->csdb->get_update('vod', $id, array('zt' => $zt));
            }
        }
    }
}
