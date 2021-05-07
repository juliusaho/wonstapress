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
    cp -a /usr/src/wordpress/wp-content/. /var/www/wp-content/
    chown -R nobody.nobody /var/www

    # Generate secrets
    curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /usr/src/wordpress/wp-secrets.php
fi
exec "$@"
