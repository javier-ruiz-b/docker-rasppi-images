#!/bin/bash
set -euo pipefail
if [ "$(whoami)" != "root" ]; then
	echo run as root!
	exit 1
fi

docker-compose down || true 

cat > db.env <<EOL
MYSQL_PASSWORD=$(cat /etc/password)
MYSQL_ROOT_PASSWORD=$(cat /etc/password)
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
NEXTCLOUD_ADMIN_PASSWORD=$(cat /etc/password)
EOL


sysctl -w net.core.somaxconn=1024
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl vm.overcommit_memory=1
echo 512 > /proc/sys/net/core/somaxconn

docker-compose build --pull
docker-compose up
