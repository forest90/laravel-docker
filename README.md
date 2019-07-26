	To enable xdebug (only for local development purposes!) run:

# WHEN CONTAINERS ARE RUNNING - LOGIN TO ACCREDITO CONTAINER WITH

	docker exec -it /bin/bash accredito_fpm

# RUN IN OPENED SHELL OF CONTAINER

	pecl install xdebug-2.5.0
	docker-php-ext-enable xdebug

	sudo echo "
	xdebug.remote_enable=1
	xdebug.remote_connect_back=1
	xdebug.remote_host="accredito.dev"
	" >> /usr/local/etc/php/php.ini

	sudo service apache2 restart


# DONT FORGET TO INSTALL BROWSER EXTENSION FOR XDEBUG
