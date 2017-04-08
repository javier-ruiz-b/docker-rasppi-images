#!/bin/bash
set -x
set -e

# //////////////////////////////////////////////////////////////
# Enable site and restart apache
a2ensite nextcloud
a2enmod rewrite

service mysql start
mysql -u root -p$DBPASS -e "CREATE DATABASE nextcloud;"
mysql -u root -p$DBPASS -e "GRANT ALL ON nextcloud.* to 'nextcloud'@'localhost' IDENTIFIED BY '$DBPASS';"
mysql -u root -p$DBPASS -e "FLUSH PRIVILEGES;"
#service mysql stop

#TODO: 
# - write 'memcache.local' => '\OC\Memcache\APCu',
# - activate HTTPS
# - letsencrypt :)


