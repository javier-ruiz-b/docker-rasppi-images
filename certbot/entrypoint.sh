#!/bin/bash
set -x
set -e

#let's encrypt 
#certbot --apache -d treso.info -d www.treso.info --agree-tos
certbot renew

