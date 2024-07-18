<?php
/**
 * @14412882 open source management system
 * @copyright 2016-2017 14412882.com. All rights reserved.
 * @Author:Chi Tu
 * @Dtime:2016-08-11
 */
//Get connection URL
function links($ac,$op='',$id=0,$where='',$admin=0){ 
   if(!empty($op)) $ac.='/'.$op;
   if(empty($where)){
	   if(empty($id)){
			$url=site_url($ac);
	   }else{
			$url=site_url($ac.'/'.$id);
	   }
   }else{
	   if(empty($id)){
			$url=is_numeric($where) ? site_url($ac.'/'.$where) : site_url($ac).'?'.$where;
	   }else{
			$url=is_numeric($where) ? site_url($ac.'/'.$id.'/'.$where) : site_url($ac.'/'.$id).'?'.$where;
	   }
   }
   //Jump from background to foreground
   if($admin==1) $url=str_replace(SELF,"index.php",$url);
   //The following is to remove index.php, which needs to support pseudo-static rules
   $url = str_replace("index.php/","",$url);
   $url = str_replace("?&","?",$url);
   return $url; 
}

//Get picture
function getpic($pic){ 
   if(empty($pic)){
		$url=base_url('attachment/nopic.png');
   }else{
		$url=$pic;
		if(substr($pic,0,7)!='http://' && substr($pic,0,8)!='https://'){
			 if(Ftp_Is==1) $url=Ftp_Url.$url;
		}
   }
   return $url; 
}
//Paging
function admin_page($url,$page,$pages){
	$phtml = '<div class="layui-box layui-laypage layui-laypage-default" id="layui-laypage-0">';
	if($page > 1){
		$phtml .= '<a href="'.$url.($page-1).'" class="layui-laypage-prev" data-page="'.($page-1).'">Pre</a>';
	}
	if($pages<6 || $page<4){
		if($pages < 2){
			return '';
		}
		if($pages<6){
			$len = $pages;
		}else{
			$len = 5;
		}
		for($i=1;$i<$len+1;$i++){
			$phtml .= page_curr($url,$page,$i);
		}
		if($pages>5){
			$phtml .= '<span>…</span><a href="'.$url.$pages.'" class="layui-laypage-last" title="Last page" data-page="'.$pages.'">Last</a>';
		}
	}else{//pages>$nums
		if($pages<$page+2){
			$phtml .= '<a href="'.$url.'1" class="laypage_first" data-page="1" title="front page">Front</a><span>…</span>';
			for($i=$pages-4;$i<$pages+1;$i++){
				$phtml .= page_curr($url,$page,$i);
			}
		}else{
			$phtml .='<a href="'.$url.'1" class="laypage_first" data-page="1" title="front page">Front</a><span>…</span>';
			for($i=$page-2;$i<$page+3;$i++){
				$phtml .= page_curr($url,$page,$i);
			}
			$phtml .= '<span>…</span><a href="'.$url.$pages.'" class="layui-laypage-last" title="Last page" data-page="'.$pages.'">Last</a>';
		}
	}
	if($page < $pages){
		$phtml .= '<a href="'.$url.($page+1).'" class="layui-laypage-next" data-page="'.($page+1).'">Next</a>';
	}
	$phtml .= '<span class="layui-laypage-total phide">to the <input id="goto_page" type="number" min="1" onkeyup="this.value=this.value.replace(/\D/, \'\')" value="'.$page.'" class="layui-laypage-skip"> Page <button type="button" onclick="goto_page(\''.$url.'\')" class="layui-laypage-btn">Go</button></span></div>';
	return $phtml;
}
function page_curr($url,$page,$i){
	$phtml = '';
	if($page==$i){
		$phtml .= '<span class="layui-laypage-curr"><em class="layui-laypage-em"></em><em>'.$page.'</em></span>';
	}else{
		$phtml .= '<a href="'.$url.$i.'" data-page="'.$i.'">'.$i.'</a>';
	}
	return $phtml;
}
function page_data($nums, $page, $pages) {
    if ($pages < 2) {
        return '';
    } else {
        return 'Total ' . $nums . ' videos in ' . $pages . ' page';
    }
}
//Front page
function get_page($num,$pages,$page=1,$ac,$op='',$id=0,$where=''){
	$phtml = '<li><a href="'.links($ac,$op,$id,$where.'&page='.($page-1)).'"><i class="fa fa-angle-left"></i></a></li>';
	if($pages<6 || $page<4){
		if($pages < 2){
			return '';
		}
		if($pages<6){
			$len = $pages;
		}else{
			$len = 5;
		}
		for($i=1;$i<$len+1;$i++){
			$clas = $page == $i ? 'active' : '';
			$phtml .= "<li class='".$clas."'><a href='".links($ac,$op,$id,$where.'&page='.$i)."'>".$i."</a></li>";
		}
		if($pages>5){
			$phtml .= '<li><a href="'.links($ac,$op,$id,$where.'&page='.$pages).'" title="Last page">Last</a></li>';
		}
	}else{//pages>$nums
		if($pages<$page+2){
			$phtml .= '<li><a href="'.links($ac,$op,$id,$where.'&page=1').'" title="Front page">Front</a></li>';
			for($i=$pages-4;$i<$pages+1;$i++){
				$clas = $page == $i ? 'active' : '';
				$phtml .= "<li class='".$clas."'><a href='".links($ac,$op,$id,$where.'&page='.$i)."'>".$i."</a></li>";
			}
		}else{
			$phtml .='<li><a href="'.links($ac,$op,$id,$where.'&page=1').'" title="Front page">Front</a></li>';
			for($i=$page-2;$i<$page+3;$i++){
				$clas = $page == $i ? 'active' : '';
				$phtml .= "<li class='".$clas."'><a href='".links($ac,$op,$id,$where.'&page='.$i)."'>".$i."</a></li>";
			}
			$phtml .= '<li><a href="'.links($ac,$op,$id,$where.'&page='.$pages).'" title="Last page">Last</a></li>';
		}
	}
	if($page < $pages){
		$phtml .= '<li><a href="'.links($ac,$op,$id,$where.'&page='.($page+1)).'"><i class="fa fa-angle-right"></i></a></li>';
	}
	return $phtml;
}