#!/bin/bash

# set ENV
WEB_SERVER_IMAGE=nginx:1.18.0
VOLUMES_NGINX_CONF=/etc/nginx/conf.d
VOLUMES_NGINX_LOG=/logs/nginx
NGINX_RESTART=always

# database
MYSQL_IMAGE=mysql:5.7
VOLUMES_DATABASE=/var/lib/mysql
MYSQL_ROOT_PASSWORD='7Hhbjnr798SsIru6'
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD='kfheJrsMCGCXnUZo'
MYSQL_RESTART=always

# word press
VOLUMES_WORDPRESS_ROOT_DEFAULT=/usr/share/nginx/html
VOLUMES_WORDPRESS_ROOT=/var/www/html
WORDPRESS_DB_HOST='db:3306'
WORDPRESS_DB_USER=$MYSQL_USER
WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD

# PHP-FPM
PHP_FPM_IMAGE='php:8.0.2-fpm'
PHP_INI_ROOT='/usr/local/etc/php/php.ini'
PHP_FPM_RESTART=always

echo "
version: '3.3'

services:
    php:
        image: $PHP_FPM_IMAGE
        container_name: php
        ports:
            - '9000:9000'
        volumes:
            - ./php/php-uploads.ini:$PHP_INI_ROOT
            - ./html:$VOLUMES_WORDPRESS_ROOT_DEFAULT
        restart: $PHP_FPM_RESTART

    nginx:
        image: $WEB_SERVER_IMAGE
        container_name: nginx
        depends_on:
            - php
        ports:
            - '80:80'
        volumes:
            - ./nginx/conf.d:$VOLUMES_NGINX_CONF
            - ./logs/nginx:$VOLUMES_NGINX_LOG
            - ./html:$VOLUMES_WORDPRESS_ROOT_DEFAULT
        restart: $NGINX_RESTART

    db:
        image: $MYSQL_IMAGE
        container_name: db
        depends_on:
            - nginx
        ports:
            - 127.0.0.1:3306:3306
        volumes:
            - ./db_data:$VOLUMES_DATABASE
        environment:
            MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
            MYSQL_DATABASE: $MYSQL_DATABASE
            MYSQL_USER: $MYSQL_USER
            MYSQL_PASSWORD: $MYSQL_PASSWORD
        restart: $MYSQL_RESTART

" > docker-compose.yml

if [[ "$?" == "0" ]]; then
    echo 'making docker-compose.yml ... [ ok ]'
    docker-compose down
    docker-compose stop
    docker-compose up -d
else
    echo "error $?";
fi
