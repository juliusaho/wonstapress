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

// Needed for plugin check
include_once(ABSPATH.'wp-admin/includes/plugin.php');

function run_activate_plugin( $plugin ) {
    $current = get_option( 'active_plugins' );
    $plugin = plugin_basename( trim( $plugin ) );

    if ( !in_array( $plugin, $current ) ) {
        $current[] = $plugin;
        sort( $current );
        do_action( 'activate_plugin', trim( $plugin ) );
        update_option( 'active_plugins', $current );
        do_action( 'activate_' . trim( $plugin ) );
        do_action( 'activated_plugin', trim( $plugin) );
    }

    return null;
}

// Function for initializing new website
function init_wonsta(){

    if(get_option('wonsta_setup') === false){

        // Setup basic details of installation
        if(getenv('WORDPRESS_DESCRIPTION')){
            update_option( 'blogdescription', getenv('WORDPRESS_DESCRIPTION') );
        }

        if(getenv('WORDPRESS_NAME')){
            update_option( 'blogname', getenv('WORDPRESS_NAME') );
        }

        if(getenv('WORDPRESS_TEMPLATE')){
            $theme = wp_get_theme(getenv('WORDPRESS_TEMPLATE'));
            if($theme && $theme->exists()){
                switch_theme(getenv('WORDPRESS_TEMPLATE'));
            }
        }
        
        // Setup plugins
        $plugins = array('jwt-auth/jwt-auth.php', 'elementor/elementor.php', 'wp-force-ssl/wp-force-ssl.php');

        foreach($plugins as $slug){
            if(!is_plugin_active($slug)){
                run_activate_plugin($slug);
            }
        }
        
        define('JWT_AUTH_SECRET_KEY', 'your-top-secret-key');

        add_option('wonsta_setup', true, '', false);
    }
    
}

add_action('init', 'init_wonsta', 20); 

?>