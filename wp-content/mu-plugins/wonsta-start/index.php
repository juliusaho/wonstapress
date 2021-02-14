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

// Function for initializing new website
function init_wonsta(){
    update_option( 'blogname', "new title" );
}

add_action('init', 'init_wonsta', 20); 

?>