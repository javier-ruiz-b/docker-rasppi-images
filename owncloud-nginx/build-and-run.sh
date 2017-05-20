#/bin/sh

if [ -z $1 ]; then
	echo Please write the DB password as argument
    exit 1
fi

set -e
set -x

docker image build --build-arg DBPASS=$1 . -t owncloud-nginx
if [[ $(docker volume ls -q) != *"owncloud-db"* ]]; then
    docker volume create owncloud-db 
    docker container run --rm -p81:80 -p444:443 \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /nextcloud-data:/nextcloud-data \
	-v owncloud-db:/var/lib/mysql \
	owncloud-nginx \
	bash -x /root/createdb.sh $1
fi

docker container run -p81:80 -p444:443 \
        -v /etc/letsencrypt:/etc/letsencrypt \
        -v /nextcloud-data:/nextcloud-data \
        -v owncloud-db:/var/lib/mysql \
        --name owncloud \
        owncloud-nginx 
