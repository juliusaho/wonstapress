<?php
/*
Plugin Name: Wonsta Start
Plugin URI:  https://wonsta.io
Description: Must-use Wonsta plugin for website creation
Version:     0.1
Author:      Wonsta
Author URI:  https://wonsta.io
License:     GPL2 etc

*/
// Basic security, prevents file from being loaded directly.
defined( 'ABSPATH' ) or die( 'Cheatin&#8217; uh?' );

// Function for initializing new website
function init_wonsta(){
    update_option( 'blogname', getenv(MARIADB_HOST) );
}

add_action('init', 'init_wonsta', 20); 

?>