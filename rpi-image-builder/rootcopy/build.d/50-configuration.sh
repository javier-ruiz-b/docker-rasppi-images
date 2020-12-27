#!/bin/bash

# echo "pi:" | chpasswd
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# systemctl daemon-reload
# systemctl enable http-server-home.service
# systemctl enable ledify
# systemctl enable noip2
# systemctl enable pilight
# systemctl enable pilight-watchdog
systemctl enable ssh
systemctl enable stream-camera
systemctl enable wpa_supplicant

# systemctl enable motioneye
# systemctl enable motion

echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
