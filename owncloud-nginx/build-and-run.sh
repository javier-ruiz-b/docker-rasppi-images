#/bin/sh

if [ -z $1 ]; then
	echo Please write the DB password as argument
    exit 1
fi

set -e
set -x

docker image build --build-arg DBPASS=$1 . -t owncloud-nginx
docker container run -p81:80 -p444:443 \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /nextcloud-data:/nextcloud-data \
	--name owncloud \
	owncloud-nginx
