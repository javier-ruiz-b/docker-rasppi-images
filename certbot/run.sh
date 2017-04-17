#!/bin/sh -x
set -e

if [ $# -ne 2 ]; then
	echo "Usage: $0 [email] [domain]"
	exit 1
fi

mkdir -p /etc/letsencrypt
echo "non-interactive = True" > /etc/letsencrypt/cli.ini
echo "email = $1" >> /etc/letsencrypt/cli.ini

docker build . -t certbot 
docker run -p80:80 -p443:443 -it --rm \
	-v "/etc/letsencrypt:/etc/letsencrypt" \
	-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
	--name certbot certbot certbot certonly --standalone --agree-tos -d $2
