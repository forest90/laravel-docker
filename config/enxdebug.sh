#!/bin/bash

pecl install xdebug-2.5.0
docker-php-ext-enable xdebug

sudo echo "
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_host="accredito.dev"
" >> /usr/local/etc/php/php.ini

service apache2 restart
