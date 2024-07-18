<?php
if (!defined('BASEPATH')) exit('No direct script access allowed');
class Ffmpeg {
    function __construct() {
        set_time_limit(0);
        $this->zmpath = FCPATH.'packs/ffmpeg/zimu.ass';
        $this->sypath = FCPATH.'packs/ffmpeg/logo.png';
        $this->ffmpeg = FCPATH.'packs/ffmpeg/ffmpeg';
        $this->ffprobe = FCPATH.'packs/ffmpeg/ffprobe';
        if(strpos(php_uname(), 'Windows') !== false){
            $this->ffmpeg .= '.exe';
            $this->ffprobe .= '.exe';
            $this->zmpath = str_replace(FCPATH, '', $this->zmpath);
            $this->sypath = str_replace(FCPATH, '', $this->sypath);
        }
    }

    public function transcode($mp4_path,$m3u8_path=''){
        if(substr($m3u8_path,0,2) == './'){
            $m3u8_path = FCPATH.substr($m3u8_path,2);
        }
        $mp4_path = str_replace('//', '/', $mp4_path);
        $m3u8_path = str_replace('//', '/', $m3u8_path);
        //Get video info command
        $format = $this->format($mp4_path);
        $m3u8_time = Zm_Time;       //ts duration
        //jpg
        $jpg = $this->vodtojpg($mp4_path,$m3u8_path);
        //subtitle + watermark
        $watermark = $this->watermark_zm();
        //zoom
        $change = Zm_Size != '' ? '-s '.Zm_Size : '';
        $Zm_Kbps = (int)Zm_Kbps;
        $bit_rate = (int)$format['bit_rate'];
        $kbps = '';
        if($bit_rate > 0){
        	$bit = $bit_rate / 1000;
        	if($Zm_Kbps > 0 && $bit > $Zm_Kbps){
                $kbps = '-b:v '.$Zm_Kbps.'k';
        	}
        }
        //speed
        $prearr = array('ultrafast','superfast','veryfast','faster','fast','medium','slow','slower');
        $preset = in_array(Zm_Preset, $prearr) ? '-preset:v '.Zm_Preset : '';

        //perform conversion
        if($format['audio']=='aac' && $format['video'] == 'h264'){
            $make_command = $this->ffmpeg.' -y -i '.$mp4_path.' '.$watermark.' '.$change.' '.$kbps.' '.$preset.' -hls_time '.$m3u8_time.' -hls_segment_filename '.$m3u8_path.'%04d.ts -hls_list_size 0 '.$m3u8_path.'playlist.m3u8';
        }else{
            $make_command = $this->ffmpeg.' -y -i '.$mp4_path.' '.$watermark.' '.$change.' '.$kbps.' '.$preset.' -c:v libx264 -c:a aac -strict -2 -f hls -hls_list_size 0 -hls_time '.$m3u8_time.' -hls_segment_filename '.$m3u8_path.'%04d.ts '.$m3u8_path.'playlist.m3u8';
        }
        $result = exec($make_command,$arr,$log);
        if($log==0){
            return 'm3u8ok';
        }else{
            return '';
        }
    }
    //Get video details
    public function format($mp4_path){
        $arr = array(
            'video' => '',
            'audio' => '',
            'duration' => 0,
            'width' => 0,
            'height' => 0,
            'dis_ratio' => '',
            'size' => 0,
            'bit_rate' => 0
        );
        if(empty($mp4_path)) return $arr;
        $format_command = $this->ffprobe.' -v quiet -print_format json -show_format -show_streams '.$mp4_path;
        $format = shell_exec($format_command);
        $json = json_decode($format);
        $audio = '';$video = '';
        foreach($json->streams as $row){
            if($row->codec_type=='video'){
                $arr['video'] = $row->codec_name;
                $arr['duration'] = $row->duration;
                $arr['width'] = $row->width;
                $arr['height'] = $row->height;
                $arr['dis_ratio']= $row->display_aspect_ratio;
            }
            if($row->codec_type=='audio'){
                $arr['audio'] = $row->codec_name;
            }
        }
		if(empty($arr['duration'])) $arr['duration'] = $json->format->duration;
        $arr['size'] = $json->format->size;
        $arr['bit_rate'] = $json->format->bit_rate;
        return $arr;
    }
    //Video screenshot JPG
    function vodtojpg($mp4_path,$m3u8_path){
        if(Jpg_On == 0) return 'no';
        $size = Jpg_Size != '' ? '-s '.Jpg_Size : '';
        $jpg_command = $this->ffmpeg.' -y -i '.$mp4_path.' -y -f image2 -ss '.Jpg_Time.' '.$size.' -t 0.001 '.$m3u8_path.'1.jpg';
        $jpg = exec($jpg_command,$arr,$log);
        //Multiple pictures
        if(Jpg_Num > 1){
            for($i=2;$i<=Jpg_Num;$i++){
                $jpg_pos = Jpg_Time * $i; //Screenshot time
                $jpg_command = $this->ffmpeg.' -y -i '.$mp4_path.' -y -f image2 -ss '.$jpg_pos.' '.$size.' -t 0.001 '.$m3u8_path.$i.'.jpg';
                $jpg = exec($jpg_command,$arr,$log);
            } 
        }
        if($log==0){
            return 'ok';
        }else{
            return 'no';
        }
    }
    //Watermark OR subtitle
    function watermark_zm(){
    	$cmd = '';
        if(Zm_Sy > 0){
            $mar_arr = explode(':', Zm_Sylt);
            $mar1 = intval($mar_arr[0]);
            $mar2 = intval($mar_arr[1]);
            if(Zm_Sy == 1){ //Upper left
                $wz = 'overlay='.Zm_Sylt;
            }elseif(Zm_Sy == 2){ //Upper right
                $wz = 'overlay=main_w-overlay_w-'.$mar1.':'.$mar2;
            }elseif(Zm_Sy == 3){ //Bottom left
                $wz = 'overlay='.$mar1.':main_h-overlay_h-'.$mar2;
            }elseif(Zm_Sy == 4){ //Bottom right
                $wz = 'overlay=main_w-overlay_w-'.$mar1.':main_h-overlay_h-'.$mar2;
            }
            $cmd = '-vf "movie='.$this->sypath.'[wm1];[in][wm1]'.$wz.'[out]"';
        }
        //Subtitle
        if(Zm_Zm == 1){
            if(empty($cmd)){
                $cmd = '-vf "ass='.$this->zmpath.'"';
            }else{
                $cmd = str_replace('[in]', 'ass='.$this->zmpath.'[asub];[asub]', $cmd);
            }
        }
        return $cmd;
    }
}
