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

    // Setup basic details of installation
    if(getenv(WORDPRESS_DESCRIPTION)){
        update_option( 'blogdescription', getenv(WORDPRESS_DESCRIPTION) );
    }

    if(getenv(WORDPRESS_NAME)){
        update_option( 'blogname', getenv(WORDPRESS_NAME) );
    }

    if(getenv(WORDPRESS_TEMPLATE)){
        update_option( 'template', getenv(WORDPRESS_TEMPLATE) );
    }
}

add_action('init', 'init_wonsta', 20); 

?>