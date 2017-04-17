#!/bin/bash
set -x
set -e

printf "Initializing DB\n"
/etc/init.d/mysql start
mysql -u root -p$DBPASS -e "CREATE DATABASE nextcloud;"
mysql -u root -p$DBPASS -e "GRANT ALL ON nextcloud.* to 'nextcloud'@'localhost' IDENTIFIED BY '$DBPASS';"
mysql -u root -p$DBPASS -e "FLUSH PRIVILEGES;"

sed -i "20i  \'memcache.local\' => \'\\\OC\\\Memcache\\\APCu\'," config.php

