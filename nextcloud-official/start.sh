#!/bin/sh

echo MYSQL_PASSWORD=$(cat /etc/password) > db.env
MYSQL_DATABASE=nextcloud >> db.env
MYSQL_USER=nextcloud >> db.env

docker-compose build --pull
docker-compose up -d