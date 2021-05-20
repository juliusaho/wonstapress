#!/bin/bash

# terminate on errors
set -e

echo 'About to change directories'

# Remove lost+found directory
if [ -d /var/www/wp-content/lost+found ]; then
    echo 'Removing dir'
    rmdir /var/www/wp-content/lost+found 2>/dev/null
fi

# Check if volume is empty
if [ ! "$(ls -A "/var/www/wp-content" 2>/dev/null)" ]; then
    echo 'Setting up wp-content volume'
    # Copy wp-content from Wordpress src to volume
    cp -a /usr/src/wordpress/. /var/www/
    chown -R 100:101 /var/www

    # Generate secrets
    curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/wp-secrets.php
fi

if [ ! $(wp core is-installed) ]; then
    echo 'Set up database'
    # Setup database
    wp core install \
        --url=$WORDPRESS_URL \
        --admin_user=$WORDPRESS_USER \
        --admin_password="$WORDPRESS_PASSWORD" \
        --admin_email=$WORDPRESS_EMAIL \
        --title="$WORDPRESS_TITLE" \
        --skip-plugins \
        --skip-email

    echo 'Set up blog description'
    # Setup blog description
    wp option update blogdescription "$WORDPRESS_DESCRIPTION"

    echo 'Set up adminuser on first load'
    # Setup admin user
    wp user create \
        $WORDPRESS_USERNAME $WORDPRESS_EMAIL \
        --user_pass="$WORDPRESS_PASSWORD" \
        --role=administrator \
        --quiet \
        --porcelain || true


    # Setup page builder if is set
    if [ ! $WORDPRESS_BUILDER == "builder" ]; then
        echo 'Installing page builder'
        wp plugin install \
        $WORDPRESS_BUILDER \
        --activate \
        --force \
        --quiet || true
    fi

    echo 'Update WP'
    # Update WordPress
    wp core update

    # Update WordPress database
    wp core update-db

    # Setup correct ownership
    chown -R nginx.nginx /var/www/wp-content
else
    echo 'WordPress core already installed, skipping wp-cli setup'
fi


exec "$@"
