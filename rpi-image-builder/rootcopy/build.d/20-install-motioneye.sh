#!/bin/sh
#install motioneye
apt-get install -yq \
    curl \
    ffmpeg \
    motion \
    python-pip \
    python-dev \
    python-setuptools \
    libssl-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libmicrohttpd12 \
    libz-dev \
    v4l-utils

apt-get purge -yq motion

wget https://github.com/Motion-Project/motion/releases/download/release-4.3.2/pi_buster_motion_4.3.2-1_armhf.deb
dpkg -i pi_buster_motion_*_armhf.deb
rm pi_buster_motion_*_armhf.deb

pip install motioneye

mkdir -p /etc/motioneye /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
