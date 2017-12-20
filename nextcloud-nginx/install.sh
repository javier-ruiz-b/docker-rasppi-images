#!/bin/bash
set -euo pipefail

# Configuring php
sed -i 's/upload_max_filesize.*$/upload_max_filesize = 16G/g' /etc/php/php.ini
sed -i 's/post_max_size.*$/post_max_size = 16G/g' /etc/php/php.ini
sed -i 's/max_input_time.*$/max_input_time = 3600/g' /etc/php/php.ini
sed -i 's/max_execution_time.*$/max_execution_time = 3600/g' /etc/php/php.ini

echo "innodb_flush_log_at_trx_commit = 2" >> /etc/mysql/my.cnf 

# ///////////////// nextcloud configuration script ///////////////////
ocpath='/var/www/nextcloud'
htuser='www-data'
htgroup='www-data'
rootuser='root'

printf "Creating possible missing Directories\n"
mkdir -p $ocpath/data
mkdir -p $ocpath/assets
mkdir -p $ocpath/updater

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
chmod 755 ${ocpath}

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/updater/

chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocpath}/data/.htaccess ]
 then
  chmod 0644 ${ocpath}/data/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess
fi

