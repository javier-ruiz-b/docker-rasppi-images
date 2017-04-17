#!/bin/bash
set -x
set -e

#let's encrypt 
echo "non-interactive = True" > /etc/letsencrypt/cli.ini
echo "email = tras3@gmx.net" >> /etc/letsencrypt/cli.ini
#certbot --apache -d treso.info -d www.treso.info --agree-tos

certbot renew

