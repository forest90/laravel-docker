FROM php:7.1-apache

ARG DEBIAN_FRONTED=noninteractive


                    # Install cli programs


ADD ./provision.sh /provision.sh

RUN ["chmod", "+x", "/provision.sh"]

RUN ["sh", "/provision.sh"]

                    # Install php ext


RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev

RUN apt-get install -y libmcrypt-dev libpng-dev libxslt-dev zlib1g-dev

RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install -j$(nproc) mcrypt mysqli pdo_mysql xsl zip bcmath pcntl

RUN pecl install redis-3.1.1

RUN docker-php-ext-enable redis

RUN pecl install xdebug-2.5.0

RUN apt-get install -y gettext-base cron


                    # Info


ADD --chown=1000:1000 config/index.php /var/www/html/public/index.php


                    # Config system


RUN LANG="en_US.utf8"

RUN ln -s /usr/local/bin/php /bin/php

RUN ln -s /usr/local/bin/php /usr/bin/php

COPY config/php.ini /usr/local/etc/php/

ENV APACHE_SERVERNAME=localhost

ENV APACHE_RUN_USER=#1000

ENV APACHE_RUN_GROUP=#1000

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

WORKDIR /var/www/html

RUN chown -R admin:admin /var/www/html

RUN chmod -R 764 /var/www/html

#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf


                    # Setup services


ADD ./config/supervisord.conf /etc/supervisor/conf.d/supervisor.conf

ADD ./config/supervisor.conf /etc/supervisor/supervisor.conf

ADD ./config/default.conf /etc/apache2/sites-available/000-default.conf

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/servername.conf

RUN a2enconf servername

RUN a2enmod rewrite


                    # Run services


ADD ./config/translations.sh /translations.sh

RUN ["chmod", "+x", "/translations.sh"]

RUN ["sh", "/translations.sh"]


ADD ./config/entrypoint.sh /entrypoint.sh

RUN ["chmod", "+x", "/entrypoint.sh"]

COPY ./config/crontab /crontab



ADD ./config/apacheenvvars /etc/apache2/envvars

ADD ./config/auth.json /home/admin/.composer/auth.json

ADD ./config/auth.json /home/root/.composer/auth.json

ADD ./config/composer.json /var/www/html/composer.json

RUN sudo n 6

RUN apt-get update && apt-get install -y iputils-ping procps

USER admin

ADD ./config/.composer /home/admin/.composer

RUN sudo chown -R admin:admin /home/admin/.composer

RUN crontab /crontab

RUN sudo /usr/sbin/cron

RUN sudo service apache2 stop

RUN sudo service apache2 force-reload || true

RUN sudo service apache2 start

CMD ["sh", "/entrypoint.sh"]

USER root


