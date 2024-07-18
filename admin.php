<?php
define('IS_ADMIN', TRUE); // Background Logo
define('SELF', pathinfo(__FILE__, PATHINFO_BASENAME)); // Background file name
define('FCPATH', str_replace("\\", DIRECTORY_SEPARATOR, dirname(__FILE__).DIRECTORY_SEPARATOR)); // Website root directory
require('index.php'); // Import main file
