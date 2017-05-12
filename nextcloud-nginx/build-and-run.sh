#/bin/sh

if [ -z $1 ]; then
	echo Please write the DB password as argument
    exit 1
fi

set -e
set -x

mkdir -p config data db
docker image build --build-arg DBPASS=$1 . -t nextcloud-nginx
docker container run -p80:80 -p443:443 \
	-v /etc/letsencrypt:/etc/letsencrypt \
	-v /nextcloud-data:/nextcloud-data \
	--name nextcloud \
	nextcloud-nginx
