#/bin/sh -x

set -e

if [ -z $1 ]; then
	echo Please write the DB password as argument
fi

mkdir -p config data db
docker build --build-arg DBPASS=$1 . -t nextcloud-nginx

docker run -p80:80 -p443:443 --rm --name nextcloudnginx nextcloud-nginx
