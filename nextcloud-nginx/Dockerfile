FROM debian:jessie
#FROM armhf/debian:jessie

#Install MariaDB
ARG DBPASS
RUN export DEBIAN_FRONTEND=noninteractive
RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list
RUN apt-get update -qq && apt-get install -y --no-install-recommends debconf-utils \
	&& echo mariadb-server-10.0 mysql-server/root_password password $DBPASS | debconf-set-selections \
	&& echo mariadb-server-10.0 mysql-server/root_password_again password $DBPASS | debconf-set-selections
ENV DBPASS=$DBPASS
RUN apt-get install -y --no-install-recommends mariadb-server -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing

#Install other packages
RUN apt-get install -y --no-install-recommends \
    bash \
    bzip2 \
    ca-certificates \
    curl \
    openssl \
    wget

# Get nginx
RUN apt-get install -t jessie-backports -y --no-install-recommends \
	nginx \
	nginx-full

# Get nextcloud
RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2 2> /dev/null \
    && wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2.sha512 2> /dev/null \
    && shasum -a 512 - < latest-11.tar.bz2.sha512 < latest-11.tar.bz2 \
    && mkdir -p /var/www \
    && tar xfj latest-11.tar.bz2 -C /var/www \
    && rm latest-11.tar.bz2*

# Compile PHP7 from source
RUN apt-get update -qq && apt-get install -t jessie-backports -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    git \
    libfcgi-dev \
    libfcgi0ldbl \
    libjpeg62-turbo-dbg \
    libmcrypt-dev \
    libc-client2007e \ 
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libkrb5-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    pkg-config \
    re2c \
    && git clone https://github.com/php/php-src \
    && cd php-src \
    && git checkout PHP-7.1 \
    && chmod +x ./buildconf \
    && ./buildconf && ./configure --prefix=/opt/php-7.1 --with-pdo-pgsql --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --with-pcre-regex --with-mysqli --with-pdo-mysql --with-mysqli --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data --with-fpm-group=www-data --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --enable-opcache --enable-fpm \
    && make -j2 \
    && make install \
    && apt-get purge -y \
    autoconf \
    bison \
    build-essential \
    git \
    libfcgi-dev \
    libfcgi0ldbl \
    libjpeg62-turbo-dbg \
    libmcrypt-dev \
    libc-client2007e \ 
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libkrb5-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    pkg-config \
    re2c \
    && cd /tmp \
    && rm -rf /tmp/*

COPY install.sh /tmp/
RUN /bin/bash -x ./install.sh
COPY entrypoint.sh /tmp/
COPY nextcloud-nginx.conf /etc/nginx/sites-enabled/nextcloud

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/tmp/entrypoint.sh"] 
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
