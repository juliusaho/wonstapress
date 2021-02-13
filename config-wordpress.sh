#!/bin/bash

# Path to WordPress
WORDPRESS_ROOT=/bitnami/wordpress

# Use WP-CLI to delete unnecessary stock plugins
PLUGINS_TO_DELETE=(
    akismet
    hello-dolly
)

if [ -n $PLUGINS_TO_DELETE ]; then
for plugin_id in ${PLUGINS_TO_DELETE[@]}; do
	echo "$plugin_id";
  wp plugin delete $plugin_id --path=$WORDPRESS_ROOT --color --allow-root
done
fi

# Use WP-CLI to install plugins
PLUGINS_TO_INSTALL=(
    wp-super-cache
)

if [ -n $PLUGINS_TO_INSTALL ]; then
for plugin_id in ${PLUGINS_TO_INSTALL[@]}; do
	echo "$plugin_id";
  wp plugin install $plugin_id --activate --path=$WORDPRESS_ROOT --color --allow-root
done
fi


# Use WP-CLI to delete the stock themes
THEMES_TO_DELETE=(
    twentyfifteen
    twentysixteen
    twentyseventeen
)

if [ -n $THEMES_TO_DELETE ]; then
for theme_id in ${THEMES_TO_DELETE[@]}; do
	echo "$theme_id";
  wp theme delete $theme_id --path=$WORDPRESS_ROOT --color --allow-root
done
fi