FROM debian:buster
LABEL Maintainer="Julius Aho"

# Install packages
RUN apt-get update && apt-get upgrade
RUN apt-get -y install php-fpm php-mysqli php-mysql php-fpm php-cli php-mbstring php-curl php-gd php-intl php-soap php-xml php-xmlrpc php-zip php-json php-opcache php-simplexml php-ctype php-imagick php-xmlreader php-xmlwriter php-dom php-phar 
RUN apt-get -y install nginx supervisor curl bash less brotli fail2ban redis sudo

RUN apt-get -y install wget
RUN apt-get -y install vim

# Configure nginx
COPY config/global /etc/nginx/global
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# wp-content volume
VOLUME /var/www/
WORKDIR /var/www/
RUN sudo chown -R www-data.www-data /var/www

# WordPress (check SHA1 from WordPress)
ENV WORDPRESS_VERSION 5.7.2
ENV WORDPRESS_SHA1 c97c037d942e974eb8524213a505268033aff6c8
ENV WORDPRESS_DATABASE_NAME localhost
ENV WORDPRESS_DATABASE_USER localhost
ENV WORDPRESS_DATABASE_PASSWORD localhost
ENV WORDPRESS_USERNAME username
ENV WORDPRESS_PASSWORD password
ENV WORDPRESS_DESCRIPTION New WonstaPress site
ENV WORDPRESS_URL localhost
ENV WORDPRESS_TITLE WonstaPress
ENV WORDPRESS_EMAIL email@wonsta.io
ENV WORDPRESS_PAGES Front
ENV WORDPRESS_BUILDER builder
ENV WORDPRESS_DEBUG false
ENV WORDPRESS_DEBUG_LOG false
ENV WORDPRESS_LANGUAGE en
RUN mkdir -p /usr/src

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \    
	&& sudo chown -R www-data.www-data /usr/src/wordpress

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# WP config
COPY wp-config.php /usr/src/wordpress
RUN sudo chown www-data.www-data /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
COPY wp-secrets.php /usr/src/wordpress
RUN sudo chown www-data.www-data /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php

RUN mkdir -p /var/entrypoint
# Entrypoint to copy wp-content
COPY entrypoint.sh /var/entrypoint/entrypoint.sh

# Copy mu-plugins
COPY mu-plugins /usr/src/wordpress/wp-content/mu-plugins

ENTRYPOINT [ "/var/entrypoint/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

