#!/bin/bash
set -x
set -e

DBPASS=$1

printf "Initializing DB\n"
cp -rf /tmp/mysql/* /var/lib/mysql
chown mysql:mysql -R /var/lib/mysql

/etc/init.d/mysql start
mysql -u root -p$DBPASS -e "CREATE DATABASE owncloud;"
mysql -u root -p$DBPASS -e "GRANT ALL ON owncloud.* to 'root'@'localhost' IDENTIFIED BY '$DBPASS';"
mysql -u root -p$DBPASS -e "FLUSH PRIVILEGES;"

