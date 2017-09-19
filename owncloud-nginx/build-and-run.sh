#/bin/bash

if [ -z $1 ]; then
	echo Please write the DB password as argument
    exit 1
fi

set -euo pipefail

docker image build --build-arg DBPASS=$1 . -t owncloud-nginx
if [[ "$(docker volume ls -q)" != *"owncloud-db"* ]]; then
    docker volume create owncloud-db 
    docker container run --rm -p80:80 -p443:443 \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /media/usb-owncloud/owncloud-data:/owncloud-data \
	-v owncloud-db:/var/lib/mysql \
	owncloud-nginx \
	bash -x /root/createdb.sh $1
fi

docker container run -p80:80 -p443:443 \
        -v /etc/letsencrypt:/etc/letsencrypt \
        -v /media/usb-owncloud/owncloud-data:/owncloud-data \
        -v owncloud-db:/var/lib/mysql \
        --name owncloud \
        owncloud-nginx 
