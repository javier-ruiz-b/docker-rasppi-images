#!/bin/bash -x

##########
# CONFIG #
##########

# CentOS 6: /usr/bin/mysql
# FreeBSD: /usr/local/bin/mysql
mysqlbin='mysql'

# The location where OwnCloud is installed
ownclouddir='/var/www/owncloud'

#################
# ACTUAL SCRIPT #
#################

dbhost=$(grep dbhost "${ownclouddir}/config/config.php" | cut -d "'" -f 4)
dbuser=$(grep dbname "${ownclouddir}/config/config.php" | cut -d "'" -f 4)
dbpass=$(grep dbpassword "${ownclouddir}/config/config.php" | cut -d "'" -f 4)
dbname=$(grep dbname "${ownclouddir}/config/config.php" | cut -d "'" -f 4)
dbprefix=$(grep dbtableprefix "${ownclouddir}/config/config.php" | cut -d "'" -f 4)

"${mysqlbin}" --silent --host="${dbhost}" --user="${dbuser}" --password="${dbpass}" --execute="DELETE FROM ${dbprefix}file_locks WHERE ttl < UNIX_TIMESTAMP();" "${dbname}"

