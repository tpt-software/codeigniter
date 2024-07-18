<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
class CS_Loader extends CI_Loader {

	public function __construct()
	{
		parent::__construct();
		log_message('debug', "MY_Loader Class Initialized");
	}

	//Website Template Switching
    public function get_templates($dir='')
    {
		if(defined('IS_ADMIN')){
            $this->_ci_view_paths = array(VIEWPATH.'admin'.DIRECTORY_SEPARATOR => TRUE);
		}else{
            $this->_ci_view_paths = array(VIEWPATH.'skins'.DIRECTORY_SEPARATOR => TRUE);
		}
    }
}

/* End of file MY_Loader.php */
/* Location: ./application/core/MY_Loader.php */
