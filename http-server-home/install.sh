#!/bin/bash
set -euxo pipefail

if [ "$(id -u)" != "0" ]; then
    echo "Run as root"
    exit 1
fi

#pip3 install -r requirements.txt

dir="$(pwd)"
cp -f http-server-home.service /etc/systemd/system
chmod +x main.py

sed -i "s#{pythonfile}#$dir/main.py#g" /etc/systemd/system/http-server-home.service

systemctl daemon-reload
systemctl enable http-server-home.service
systemctl restart http-server-home.service
