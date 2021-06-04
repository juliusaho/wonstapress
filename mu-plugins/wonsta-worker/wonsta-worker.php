<?php
/*
 * Plugin Name:       Wonsta Worker
 * Plugin URI:        https://wonsta.io
 * Description:       Must use Wonsta plugin for extending WordPress-features and communicating to Wonsta API
 * Version:           1.0.0
 * Author:            Wonsta Inc
 * Author URI:        https://wonsta.io
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       wonsta-worker
 */
// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

define( 'WONSTA_WORKER', 'wonsta-worker' );
define( 'PLUGIN_NAME_BASE_DIR', plugin_dir_path( __FILE__ ) );
define( 'PLUGIN_NAME_BASE_NAME', plugin_basename( __FILE__ ) );
define( 'PLUGIN_FILE_URL', __FILE__);

function activate_plugin_wonsta_worker() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-wonsta-custom-routes.php';
	$api = new Wonsta_Custom_Route();
    $api->register_routes();
}

add_action( 'rest_api_init', 'activate_plugin_wonsta_worker' );