#!/bin/bash
set -x
set -e

echo "ServerName localhost" | tee /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn

# Enable site and restart apache
a2ensite 000-default
a2ensite nextcloud
a2enmod rewrite

printf "Initializing DB\n"
/etc/init.d/mysql start
mysql -u root -p$DBPASS -e "CREATE DATABASE nextcloud;"
mysql -u root -p$DBPASS -e "GRANT ALL ON nextcloud.* to 'nextcloud'@'localhost' IDENTIFIED BY '$DBPASS';"
mysql -u root -p$DBPASS -e "FLUSH PRIVILEGES;"

service apache2 restart
#certbot --apache
#letsencrypt --apache -d treso.ddns.net

sed -i "20i  \'memcache.local\' => \'\\\OC\\\Memcache\\\APCu\'," config.php

