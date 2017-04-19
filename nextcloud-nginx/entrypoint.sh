#!/bin/bash
set -x
set -e

/etc/init.d/mysql start
/etc/init.d/php-7.1-fpm start
nginx

bash
