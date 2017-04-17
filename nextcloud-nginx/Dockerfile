FROM debian:jessie
#FROM armhf/debian:jessie

#Install MariaDB
ARG DBPASS
RUN export DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list \
     && echo 'deb http://packages.dotdeb.org jessie-nginx-http2 all' | tee /etc/apt/sources.list.d/backports.list \
     && echo 'deb-src http://packages.dotdeb.org jessie-nginx-http2 all' | tee /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y --no-install-recommends debconf-utils 
RUN echo mariadb-server-10.0 mysql-server/root_password password $DBPASS | debconf-set-selections \
    && echo mariadb-server-10.0 mysql-server/root_password_again password $DBPASS | debconf-set-selections
ENV DBPASS=$DBPASS
RUN apt-get install -y --no-install-recommends mariadb-server -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing

#Install other packages
RUN apt-get install -y --no-install-recommends \
				bash \
				bzip2 \
				curl \
				openssl \
				wget
#                && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2 
RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2.sha512
RUN shasum -a 512 - < latest-11.tar.bz2.sha512 < latest-11.tar.bz2
RUN rm latest-11.tar.bz2.sha512
RUN tar xfj latest-11.tar.bz2 -C /var/www

COPY install.sh /tmp/
RUN /bin/bash -x ./install.sh
COPY entrypoint.sh /tmp/


RUN apt-get install -y --no-install-recommends \
				nginx \
				nginx-full

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/tmp/entrypoint.sh"] 
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
