#!/bin/bash
set -x
#git clone https://github.com/php/php-src.git php
#cd php
git pull
git checkout PHP-7.1
./buildconf
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
./configure

