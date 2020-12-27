#!/bin/sh

sudo modprobe bcm2835_wdt
echo "bcm2835_wdt" | sudo tee -a /etc/modules

apt-get install -yq watchdog
update-rc.d watchdog defaults

echo "watchdog-timeout = 30" >> /etc/watchdog.conf