# WordPress with Docker common patterns

## wp1
This is the default `docker-compose.yml` provided by Docker Inc. It has two
images, one for database and the other for WordPress in which Nginx and Apache
have been configured.

## wp2
This is WordPress image which has been configured using PHP-FPM 7.4, plus other
needed services, e.g. Nginx, MySql, etc

## wp3 ( incomplete )
This one is complete separated services
