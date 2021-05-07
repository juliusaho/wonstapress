<?php

define('WP_CONTENT_DIR', '/var/www/wp-content');

$table_prefix  = getenv('TABLE_PREFIX') ?: 'wp_';

// a helper function to lookup "env_FILE", "env", then fallback
if (!function_exists('getenv_docker')) {
	// https://github.com/docker-library/wordpress/issues/588 (WP-CLI will load this file 2x)
	function getenv_docker($env, $default) {
		if ($fileEnv = getenv($env . '_FILE')) {
			return rtrim(file_get_contents($fileEnv), "\r\n");
		}
		else if (($val = getenv($env)) !== false) {
			return $val;
		}
		else {
			return $default;
		}
	}
}

foreach ($_ENV as $key => $value) {
    $capitalized = strtoupper($key);
    if (!defined($capitalized)) {
        define($capitalized, $value);
    }
}

define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );

define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', 'example username') );

define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', 'example password') );

define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );

if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}

require_once(ABSPATH . 'wp-secrets.php');
require_once(ABSPATH . 'wp-settings.php');
