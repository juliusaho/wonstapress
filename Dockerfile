FROM wordpress:5-php7.2-fpm-alpine

RUN apk --no-cache add openssl imagemagick perl

ENV PHPREDIS_VERSION=5.0.2 \
    CONFIG_VAR_FLAG=WPFPM_ \
    PAGER=more \
    WP_PLUGINS="nginx-helper redis-cache" \
    ENABLE_CRON=false

RUN docker-php-source extract \
  && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
  && tar xfz /tmp/redis.tar.gz \
  && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
  && docker-php-ext-install redis \
  && docker-php-source delete \
  && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp \
  && rm -r /tmp/*

# PHP-FPM Upload limit increase
ADD config/php-fpm/uploads.ini /usr/local/etc/php/conf.d/

# Shell nice-to-haves
ADD config/bash/.bashrc /root

CMD ["php-fpm"]