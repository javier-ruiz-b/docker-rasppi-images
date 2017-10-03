#!/bin/bash
set -euo pipefail

if test $# -lt 2; then
    echo "Usage: $(basename $0) ROOT_PASSWORD FOLDER_TO_MOUNT"
    exit 1 
fi

docker image build -t alpine-sshd docker/
docker run \
	-d \
	-e ROOT_PASSWORD=$1 \
	-v "$2":/mount \
	--restart always \
	--name sshd \
	-p 33322:22 \
	alpine-sshd
