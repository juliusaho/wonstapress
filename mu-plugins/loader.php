<?php
/** 
* Plugin Name: Wonsta MU-Loader
* Description: Must use plugins to use Wonsta 
* Version:     1.0
* Text Domain: wonsta_loader
* Author:      Wonsta
* Author URI:  https://wonsta.io
* License:     MIT
* License URI: https://opensource.org/licenses/MIT
*/
require WPMU_PLUGIN_DIR.'/wonsta-worker/wonsta-worker.php';
require WPMU_PLUGIN_DIR.'/redis-cache/redis-cache.php';
require WPMU_PLUGIN_DIR.'/wp-password-bcrypt/wp-password-bcrypt.php';
require WPMU_PLUGIN_DIR.'/autoptimize/autoptimize.php';