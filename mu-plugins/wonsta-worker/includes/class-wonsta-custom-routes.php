<?php

class Wonsta_Custom_Route extends WP_REST_Controller {

  public function init (){

    include_once( ABSPATH . 'wp-admin/includes/plugin-install.php' ); 
    include_once( ABSPATH . 'wp-admin/includes/plugin.php' );

    //includes necessary for Plugin_Upgrader and Plugin_Installer_Skin
    include_once( ABSPATH . 'wp-admin/includes/file.php' );
    include_once( ABSPATH . 'wp-admin/includes/misc.php' );
    include_once( ABSPATH . 'wp-admin/includes/class-wp-upgrader.php' );

    // setup custom skin
    include_once( 'upgrader.php' );

  }

  public function wonsta_get_plugin_dir($plugin) {

      $chunks = explode( '/', $plugin );
      if ( ! is_array( $chunks ) ) {
          $plugin_dir = $chunks;
      } else{
          $plugin_dir = $chunks[0];
      }
      return WP_PLUGIN_DIR . "/" . $plugin_dir;

  }

  public function wonsta_update_plugin($plugin){

    $this->init();

    // get path
    $pluginDir = $this->wonsta_get_plugin_dir($plugin);
    $file = sprintf('%s/%s', $plugin, key(get_plugins("/{$plugin}")));

    // get active status
    $isActive = is_plugin_active($file);
    $api = plugins_api('plugin_information', 
      array(
        'slug' => $plugin,
        'fields' => array(
          'sections' => false
        )
      )
    );
    if (file_exists($pluginDir)) {

      $skin = new Automatic_Upgrader_Skin(array('api' => $api));
      $upgrader = new \Plugin_Upgrader( $skin );
      $upgrade = $upgrader->upgrade($file);

      if($upgrade){
        
        // WordPress by default deactivates plugins when updating. 
        if($isActive){
          activate_plugin($file);
        }

        return $upgrader->skin->get_upgrade_messages();

      }else{

        return $upgrader->skin->get_upgrade_messages();

      }

    }

  }

  public function wonsta_update_plugins($plugins){

    if(!$plugins){
      return false;
    }

      $this->init();
      $pluginFiles = [];
      $actives = [];

      foreach($plugins as $plugin){

        // get path
        $pluginDir = $this->wonsta_get_plugin_dir($plugin);
        $file = sprintf('%s/%s', $plugin, key(get_plugins("/{$plugin}")));

        if(file_exists($pluginDir)){
          $pluginFiles[] = $file;
        }
        
        if(is_plugin_active($plugin)){
          $actives[] = $file;
        }

      }
      if($pluginFiles){
        $skin = new Automatic_Upgrader_Skin();
        $upgrader = new \Plugin_Upgrader( $skin );
        $upgrade = $upgrader->bulk_upgrade($pluginFiles);
        if($upgrade){
          
          foreach($actives as $active){
            activate_plugin($active);
          }

          return $upgrader->skin->get_upgrade_messages();

        }else{
          return $upgrader->skin->get_upgrade_messages();
        }
      }

  }

  /**
   * Register the routes for the objects of the controller.
   */
  public function register_routes() {
    $version = '1';
    $namespace = 'wonsta/v' . $version;
    $base = 'plugins';

    // Endpoint for retrieving single plugin from URL param
    register_rest_route( $namespace, '/' . $base . '/update/(?P<plugin>[a-zA-Z0-9-/!"#%]+)', array(
      array(
        'methods'             => "GET",
        'callback'            => array( $this, 'update_plugin' ),
        'permission_callback' => array( $this, 'update_plugins_permissions_check' ),
        'args' => [
          'plugin' => [] 
        ],
      ),
    ) );

    // Endpoint for retrieving multiple plugins from body
    register_rest_route( $namespace, '/' . $base . '/update/', array(
      array(
        'methods'             => "POST",
        'callback'            => array( $this, 'update_plugins' ),
        'permission_callback' => array( $this, 'update_plugins_permissions_check' ),
      ),
    ) );

    register_rest_route( $namespace, '/' . $base . '/schema', array(
      'methods'  => WP_REST_Server::READABLE,
      'callback' => array( $this, 'get_public_item_schema' ),
      'permission_callback' => array( $this, 'update_plugins_permissions_check' ),
    ) );
    
  }

  /**
   * Update specified plugin
   */

  public function update_plugin( WP_REST_Request $request ) {
    
    $this->init();

    $params = $request->get_params();
    $plugin = $params['plugin'];
    if($plugin){
      if ( method_exists( $this, 'wonsta_update_plugin' ) ) {
        $data = $this->wonsta_update_plugin( $plugin );
        // TODO: Better responses for plugin update cases
        return new WP_REST_Response( 
          array(
            'status' => '200',
            'data' => $data
          )
        );
      }
    }
    
    return new WP_Error( 'cant-update', __( '404 plugin not found', 'wonsta' ), array( 'status' => 200 ) );

  }

  /**
   * Update multiple plugins
   */

  public function update_plugins(  WP_REST_Request $request ) {

    $this->init();
    $parameters = $request->get_json_params();
    $plugins = $parameters['plugins'];
    if($plugins){
      if ( method_exists( $this, 'wonsta_update_plugins' ) ) {
        $data = $this->wonsta_update_plugins( $plugins );
        return new WP_REST_Response( 
          array(
            'status' => '200',
            'data' => $data
          )
        );
      }
    }
    
    return new WP_Error( 'cant-update', __( '404 plugin not found', 'wonsta' ), array( 'status' => 200 ) );

  }



  /**
   * Check if a given request has access to update plugins
   */

  public function update_plugins_permissions_check( $request ) {
    return current_user_can( 'update_plugins' );
  }


}