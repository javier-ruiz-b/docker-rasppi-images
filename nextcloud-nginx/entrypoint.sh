#!/bin/bash
set -x
set -e

chown www-data:www-data /nextcloud-data

/etc/init.d/mysql start
/etc/init.d/php-7.1-fpm start
/etc/init.d/redis-server start

exec nginx -g 'daemon off;'

