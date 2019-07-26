FROM php:7.1-apache

ARG DEBIAN_FRONTED=noninteractive


                    # Install cli programs


ADD ./provision.sh /provision.sh

RUN ["chmod", "+x", "/provision.sh"]

RUN ["sh", "/provision.sh"]


                    # Install php ext


RUN apt-get install -y libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev

RUN apt-get install -y libmcrypt-dev libpng-dev libxslt-dev zlib1g-dev

RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/inclue/ --with-webp-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) mcrypt mysqli pdo_mysql xsl zip bcmath pcntl

RUN pecl install redis-3.1.1

RUN docker-php-ext-enable redis


                    # Config system


RUN LANG="en_US.utf8"

RUN ln -s /usr/local/bin/php /bin/php

RUN ln -s /usr/local/bin/php /usr/bin/php

COPY config/php.ini /usr/local/etc/php/

ENV APACHE_SERVERNAME=localhost

ENV APACHE_RUN_USER=#1000

ENV APACHE_RUN_GROUP=#1000

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN mkdir -p /var/www/html/public

WORKDIR /var/www/html

RUN chown -R admin:admin /var/www/html

RUN chmod -R 764 /var/www/html


                    # Setup services


ADD ./config/default.conf /etc/apache2/sites-available/000-default.conf

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf

RUN a2enconf servername

RUN a2enmod rewrite


                    # Run services


ADD ./config/apacheenvvars /etc/apache2/envvars

USER admin

RUN sudo service apache2 stop

RUN sudo service apache2 force-reload || true

RUN sudo service apache2 start

USER root


