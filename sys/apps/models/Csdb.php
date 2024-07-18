<?php
if (!defined('BASEPATH')) exit('No direct script access allowed');
class Csdb extends CI_Model{
    function __construct (){
       parent:: __construct ();
	   //Load database connection
       $this->load->database();
	}

    //SQL query
    function get_sql($sql,$arr=0){
        $query=$this->db->query($sql);
	    if($arr==0){
            return $query->result();
	    }else{
            return $query->result_array();
	    }
	}

    //The total number of SQL statement queries
    function get_sql_nums($sql='')  {
        if(!empty($sql)){
		    preg_match('/select\s*(.+)from/i', strtolower($sql),$sqlarr);
		    if(!empty($sqlarr[1])){
               $sql=str_replace($sqlarr[1],' count(*) as counta ',strtolower($sql));
			   $rows=$this->db->query($sql)->result_array();
			   $nums=(int)$rows[0]['counta'];
		    }else{
			   $query=$this->db->query($sql);
			   $nums=(int)$query->num_rows();
		    }
        }else{
           $nums=0;
        }
        return $nums;
	}

    //Query the total quantity
    function get_nums($table,$arr='',$like=''){
        if(is_array($arr)){
            foreach($arr as $k=>$v){
			    if(strpos($v,'or#') !== FALSE){
					$this->db->or_where($k,str_replace('or#', '', $v)); //condition
				}elseif(strpos($v,',') !== FALSE){
				    $v = explode(',',$v);
                    $this->db->where_in($k,$v); //condition
			    }else{
                    $this->db->where($k,$v); //condition
			    }
		    }
        }elseif(!empty($arr)){
        	$this->db->where($arr); //condition
        }
        if($like){
            foreach ($like as $k=>$v){
               $this->db->like($k,$v); //search condition
		    }
        }
        $this->db->select('count(*) as count');
        $query=$this->db->get($table);
	    $rows=$query->row_array();
	    $nums=(int)$rows['count'];
        return $nums;
	}

    //Sum of statistics
    function get_sum($zd,$table,$arr='',$like=''){
        if(is_array($arr)){
            foreach($arr as $k=>$v){
			    if(strpos($v,'or#') !== FALSE){
					$this->db->or_where($k,str_replace('or#', '', $v)); //condition
				}elseif(strpos($v,',') !== FALSE){
				    $v = explode(',',$v);
                    $this->db->where_in($k,$v); //condition
			    }else{
                    $this->db->where($k,$v); //condition
			    }
		    }
        }elseif(!empty($arr)){
        	$this->db->where($arr); //condition
        }
        if($like){
            foreach ($like as $k=>$v){
               $this->db->like($k,$v); //search condition
		    }
        }
        $this->db->select('sum('.$zd.') as sum');
        $query=$this->db->get($table);
	    $rows=$query->row_array();
	    $nums=(int)$rows['sum'];
        return $nums;
	}

    //Query a single object by condition
    function get_row($table,$fzd='*',$arr='',$order=''){
        if(is_array($arr)){
            foreach($arr as $k=>$v){
				if(strpos($v,',') !== FALSE){
					$v = explode(',',$v);
	                $this->db->where_in($k,$v); //condition
				}else{
	                $this->db->where($k,$v); //condition
				}
			}
        }else{
             $this->db->where('id',$arr);
		}
        $this->db->select($fzd);
	    if($order!=''){
            $this->db->order_by($order); //to sort
	    }
	    $query=$this->db->get($table);
	    return $query->row();
	}

    //Query a single array by condition
    function get_row_arr($table,$fzd='*',$arr=''){
        if(is_array($arr)){
            foreach ($arr as $k=>$v){
				if(strpos($v,',') !== FALSE){
					$v = explode(',',$v);
	                $this->db->where_in($k,$v); //condition
				}else{
	                $this->db->where($k,$v); //condition
				}
			}
        }else{
            $this->db->where('id',$arr);
		}
	    $this->db->select($fzd);
	    $query=$this->db->get($table);
	    return $query->row_array();
	}

    //Generate query list results, with pagination
    function get_select($table,$fzd='*',$arr='',$order='id DESC',$limit='15',$like='',$rarr=0){
		if(is_array($arr)){
			foreach ($arr as $k=>$v){
				if(strpos($v,'or#') !== FALSE){
					$this->db->or_where($k,str_replace('or#', '', $v)); //condition
				}elseif(strpos($v,',') !== FALSE){
					$v = explode(',',$v);
					$this->db->where_in($k,$v); //condition
				}else{
					$this->db->where($k,$v); //condition
				}
			}
		}elseif(!empty($arr)){
        	$this->db->where($arr); //condition
        }
		if($like){
			foreach ($like as $k=>$v){
				$this->db->like($k,$v); //search condition
			}
		}
		$this->db->select($fzd); //query field
		if(is_array($limit)){
			$this->db->limit($limit[0],$limit[1]);  //paging
		}else{
			$this->db->limit($limit);  //paging
		}
		if(is_array($order)){
			for($i=0; $i < sizeof($order)/2; $i++) {
				$this->db->order_by($order[2*$i],$order[2*$i+1]);
			}
		}else{
			$this->db->order_by($order); //to sort
		}
		$query=$this->db->get($table); //query form
		if($rarr==0){
			return $query->result();
		}else{
			return $query->result_array();
		}
	}
	
	// get cloumn size all record table vod
	function get_size_vod($table,$fzd='*'){
		$this->db->select($fzd); //query field
		$query=$this->db->get($table); //query form 
		return $query->result_array();
	}

    //Increase
    function get_insert($table,$arr){
        if($arr){
	        $this->db->insert($table,$arr);
            $ids = $this->db->insert_id();
		    return $ids;
        }else{
		    return false;
        }
	}

    //Modify
    function get_update($table,$id,$arr,$zd='id'){
        if(!empty($id)){
	        if(is_array($id)){
		        $this->db->where_in($zd,$id);
	        }else{
		        $this->db->where($zd,$id);
	        }
	        if($this->db->update($table,$arr)){
	            return true;
            }else{
		        return false;
            }
        }else{
		    return false;
        }
    }

    //Delete
    function get_del ($table,$ids,$zd='id'){
        if(is_array($ids)){
	        $this->db->where_in($zd,$ids);
        }else{
	        $this->db->where($zd,$ids);
        }
        if($this->db->delete($table)){
            return true;
        }else{
	        return false;
        }
	}
}