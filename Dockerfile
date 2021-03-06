FROM alpine:3.13
LABEL Maintainer="Julius Aho / Wonsta"

# Install packages
# Todo: Update to php 8 when WP-CLI support ready
RUN apk --no-cache add \
  php7 \
  php7-fpm \
  php7-mysqli \
  php7-json \
  php7-openssl \
  php7-curl \
  php7-zlib \
  php7-xml \
  php7-phar \
  php7-intl \
  php7-dom \
  php7-xmlreader \
  php7-xmlwriter \
  php7-exif \
  php7-fileinfo \
  php7-sodium \
  php7-gd \
  php7-imagick \
  php7-simplexml \
  php7-ctype \
  php7-mbstring \
  php7-zip \
  php7-opcache \
  php7-pecl-redis \
  php7-bcmath \
  nginx \
  supervisor \
  curl \
  bash \
  less \
  brotli \
  nginx-mod-http-brotli \
  fail2ban 

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
RUN chown -R nginx.nginx /var/www

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
ENV WORDPRESS_CACHE false
ENV WORDPRESS_LANGUAGE en

RUN mkdir -p /usr/src

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \    
	&& chown -R nginx.nginx /usr/src/wordpress

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# WP config
COPY wp-config.php /usr/src/wordpress
RUN chown nginx.nginx /usr/src/wordpress/wp-config.php && chmod 640 /usr/src/wordpress/wp-config.php

# Append WP secrets
COPY wp-secrets.php /usr/src/wordpress
RUN chown nginx.nginx /usr/src/wordpress/wp-secrets.php && chmod 640 /usr/src/wordpress/wp-secrets.php

RUN mkdir -p /var/entrypoint
# Entrypoint to copy wp-content
COPY entrypoint.sh /var/entrypoint/entrypoint.sh

# Copy mu-plugins
COPY mu-plugins /usr/src/wordpress/wp-content/mu-plugins

ENTRYPOINT [ "/var/entrypoint/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

