FROM resin/rpi-raspbian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
				clang \
				make \
				autoconf \
				automake \
				libtool \
				re2c \
				bison \
				git \
				libxml2-dev \
				bash
				

#                apache2 
#            && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY run.sh /tmp/
WORKDIR /tmp
RUN git clone https://github.com/php/php-src.git php
WORKDIR /tmp/php

CMD ["/bin/bash", "-x", "/tmp/run.sh"] 
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
