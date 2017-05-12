#/bin/sh

#if [ -z $1 ]; then
#	echo Please write the DB password as argument
#fi

mkdir -p config data db
docker-compose build
#docker build --build-arg SBPASS=$1 . -t nextcloud  
