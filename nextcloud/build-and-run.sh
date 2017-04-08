#/bin/sh

if [ -z $1 ]; then
	echo Please write the DB password as argument
fi


docker build --build-arg SBPASS=$1 . -t nextcloud  
docker run -p80:80 -p443:443 -it --rm --name nextcloud nextcloud
