FROM wordpress:latest

RUN apt-get update
RUN apt-get install sudo

RUN curl -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD wp-config.php /var/www/html/wp-config.php

RUN chown -R www-data:www-data /var/www/html
