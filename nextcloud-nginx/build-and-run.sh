#/bin/bash

if [ -z $1 ]; then
    echo Please write the DB password as argument
    exit 1
fi

set -euo pipefail

docker image build --build-arg DBPASS=$1 . -t nextcloud-nginx
if [[ "$(docker volume ls -q)" != *"nextcloud-db"* ]]; then
    docker volume create nextcloud-db
    docker container run --rm -p80:80 -p443:443 \
        -v /etc/letsencrypt:/etc/letsencrypt \
        -v /media/usb-owncloud/owncloud-data:/nextcloud-data \
        -v nextcloud-db:/var/lib/mysql \
        nextcloud-nginx \
        bash -x /root/createdb.sh $1
fi

docker container run -p80:80 -p443:443 \
        -v /etc/letsencrypt:/etc/letsencrypt \
        -v /media/usb-owncloud/owncloud-data:/nextcloud-data \
        -v nextcloud-db:/var/lib/mysql \
        --name nextcloud \
        nextcloud-nginx


