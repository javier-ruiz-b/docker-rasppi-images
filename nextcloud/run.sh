#/bin/sh -x

set -e

docker-compose down || true
docker-compose up

#docker run -p80:80 -p443:443 --rm --name nextcloud nextcloud
