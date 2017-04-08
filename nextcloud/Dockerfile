FROM debian:jessie
#FROM resin/rpi-raspbian:jessie

ARG DBPASS
ENV DBPASS=$DBPASS
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends debconf-utils \
    && echo mariadb-server-10.0 mysql-server/root_password password $DBPASS | debconf-set-selections \
    && echo mariadb-server-10.0 mysql-server/root_password_again password $DBPASS | debconf-set-selections \
    && apt-get install -y --no-install-recommends mariadb-server -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing \
    && apt-get install -y --no-install-recommends \ 
				apache2 \
				libapache2-mod-php5 \
				php5 \
				php5-gd \
				php5-json \
				php5-mysql \
				php5-curl \
				php5-intl \
				php5-mcrypt \
				php5-ldap \
				php5-imap \
				php5-gmp \
				curl \
				wget \
				openssl \
                php5-imagick \
                bzip2 \
                php5-apcu \
				bash

WORKDIR /tmp

RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2 
RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2.sha512
RUN shasum -a 512 - < latest-11.tar.bz2.sha512 < latest-11.tar.bz2
RUN rm latest-11.tar.bz2.sha512
RUN tar xfj latest-11.tar.bz2 -C /var/www

COPY nextcloud.conf /etc/apache2/sites-available/
COPY install.sh /tmp/
RUN /bin/bash -x ./install.sh
COPY run.sh /tmp/

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/tmp/run.sh"] 
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
