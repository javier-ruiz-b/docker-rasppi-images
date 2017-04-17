#/bin/sh

if [ -z $1 ]; then
	echo Please write the DB password as argument
    exit 1
fi

set -e
set -x

mkdir -p config data db
docker build --build-arg DBPASS=$1 . -t nextcloud-nginx

docker run -p80:80 -p443:443 -it --rm --name nextcloudnginx nextcloud-nginx
