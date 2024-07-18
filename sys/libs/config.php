<?php
define('Web_Name','Cloud multimedia system'); //Site name
define('Web_Url','14412882.com'); //Domain name
define('Web_Zm_Url','14412882.com'); //Transcoding domain name
define('Web_M3u8_Url',''); //M3u8 domain name
define('Web_Pic_Url',''); //Image domain name
define('Web_Path','/'); //Site path
define('Web_Reg',0);  //Member registration status, 0 review, 1 pending review
define('Web_Gg','&lt;a target=&quot;_blank&quot; href=https://14412882.com class=&quot;caption-subject font-red sbold uppercase&quot;&gt; 14412882.com &lt;/span&gt;&lt;/a&gt;
');  //Website Announcement
define('Up_Dir','./video/data/'); //Upload source file save path
define('Up_Ext','mp4|ts|mkv|mov|avi'); //Supported upload formats
define('Del_Mp4',1); //Whether to delete the source file of the deleted video
define('Del_M3u8',1); //Whether to delete the slice resource when deleting the video
define('Zm_Dir','./video/m3u8/');  //Slice save directory
define('Zm_Preset','fast'); //Slice priority
define('Zm_Time',3);  //Duration seconds per TS
define('Zm_Kbps','1080k');  //Slice rate
define('Zm_Size','');  //Slice size
define('Zm_Zm',0);  //Whether to enable subtitles. 0 off, 1 on
define('Zm_Sy',0);  //Watermark switch, 0 off, 1 upper left, 2 upper right, 3 lower left, 4 lower right
define('Zm_Sylt','1:1');  //Upper left distance border position
define('Jpg_On',1);  //Screenshot switch, 1 is on and 0 is off
define('Jpg_Num',1);  //Number of screenshots
define('Jpg_Time',180);  //Interval seconds
define('Jpg_Size','');  //Screenshot size
define('Admin_Count',''); //Statistical code
define('Tb_Zt',0); //Sync status
define('Tb_Url',''); //Sync address
define('Tb_Key',''); //Sync key