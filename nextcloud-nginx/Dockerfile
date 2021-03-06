FROM debian:stretch-slim

#Install MariaDB
ARG DBPASS
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
    && apt-get upgrade -yq \
    && apt-get install -y --no-install-recommends \
    debconf-utils \
    && echo mariadb-server-10.0 mysql-server/root_password password $DBPASS | debconf-set-selections \
    && echo mariadb-server-10.0 mysql-server/root_password_again password $DBPASS | debconf-set-selections \
    && apt-get install -y --no-install-recommends mariadb-server -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing
ENV DBPASS=$DBPASS

#Install other packages
RUN apt-get install -y --no-install-recommends \
    bash \
    bzip2 \
    ca-certificates \
    cron \
    curl \
    nginx \
    nginx-full \
    openssl \
    smbclient \
    sudo \
    wget

WORKDIR /tmp

# Compile and install PHP7.1 from source
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    git \
    libcurl4-openssl-dev \
    libfcgi-dev \
    libfcgi0ldbl \
    libjpeg62-turbo-dev \
    libmcrypt4 \
    libmcrypt-dev \
    libc-client2007e \
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libiconv-hook1 \
    libiconv-hook-dev \
    libgmp10 \
    libgmp-dev \
    libicu57 \
    libicu-dev \
    libldb1 \
    libldb-dev \
    libldap-2.4-2 \
    libldap2-dev \
    libjpeg-dev \
    libpng-dev \
    libmemcached-dev \
    libfreetype6-dev \
    libkrb5-dev \
    libpq5 \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    mlocate \
    zlib1g-dev \
    pkg-config \
    redis-server \
    re2c \
    && ln -s /usr/include/x86_64-linux-gnu/curl /usr/include/curl \
    && cd /usr/lib \
    && updatedb --prunepaths=/mnt \
    && for lib in liblber-2.4.so.2 liblber-2.4.so.2.8.3 liblber.so libldap.so libldap_r.so; do \
            if [ ! -L $lib ]; then \
                ln -s "$(locate $lib)";  \
            fi \
       done \
    && cd /tmp \
    && git clone https://github.com/php/php-src \
    && cd php-src \
    && git checkout PHP-7.1 \
    && chmod +x ./buildconf \
    && ./buildconf && ./configure CFLAGS='-O2' CXXFLAGS='-O2' --with-config-file-path=/etc/php --prefix=/ --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --enable-intl --with-pcre-regex --with-mysqli --with-pdo-mysql --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data --with-fpm-group=www-data --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --with-iconv --with-ldap=/usr --with-imap --with-gmp --enable-opcache --enable-ftp --enable-posix --enable-fpm \
    && make -j4 \
    && make install \
    && mkdir -p /etc/php \
    && cp php.ini-production /etc/php/php.ini \
    && pecl config-set php_ini /etc/php/php.ini \
    && printf "\n" | pecl install apcu \
    && printf "\n" | pecl install redis \
    && apt-get purge -y \
    autoconf \
    bison \
    build-essential \
    git \
    libcurl4-openssl-dev \
    libfcgi-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libiconv-hook-dev \
    libjpeg-dev \
    libgmp-dev \
    libicu-dev \
    libldap2-dev \
    libldb-dev \
    libpng-dev \
    libmemcached-dev \
    libfreetype6-dev \
    libkrb5-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    mlocate \
    zlib1g-dev \
    pkg-config \
    re2c \
    && cd /tmp \
    && rm -rf /tmp/* \
    && mv /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf \
    && echo 'env[HOSTNAME] = $HOSTNAME' >> /etc/php-fpm.d/www.conf \
    && echo 'env[PATH] = /usr/local/bin:/usr/bin:/bin' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TMP] = /tmp' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TMPDIR] = /tmp' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TEMP] = /tmp' >> /etc/php-fpm.d/www.conf \
    && mkdir -p /var/lib/php/session \
    && chown www-data:www-data -R /var/lib/php/session/ \
    && apt-get autoremove -y \
    && apt-get autoclean -y

# Get nextcloud
ENV NEXTCLOUD_FILE=latest-13.tar.bz2
RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/${NEXTCLOUD_FILE} 2> /dev/null \
    && wget --no-check-certificate https://download.nextcloud.com/server/releases/${NEXTCLOUD_FILE}.sha512 2> /dev/null \
    && shasum -a 512 - < ${NEXTCLOUD_FILE}.sha512 < ${NEXTCLOUD_FILE} \
    && mkdir -p /var/www \
    && rm -rf /var/www/owncloud* \
    && tar xfj ${NEXTCLOUD_FILE} -C /var/www \
    && rm ${NEXTCLOUD_FILE}* \
    && echo "*/5  *  *  *  * sudo -u www-data php -f /var/www/nextcloud/cron.php" | crontab -u www-data -

COPY custom-php.ini /etc/php/php.ini
ENV PATH=$PATH:/opt/php-7.1/bin

COPY init.d-php-7.1-fpm /etc/init.d/php-7.1-fpm
RUN chmod 755 /etc/init.d/php-7.1-fpm
COPY nextcloud-config.php /var/www/nextcloud/config/config.php
COPY nginx.conf /etc/nginx/sites-enabled/nextcloud
RUN rm /etc/nginx/sites-enabled/default
COPY install.sh /tmp/
RUN /bin/bash -x ./install.sh

COPY createdb.sh /root/
COPY entrypoint.sh /root/
RUN rm -rf && \
    cp -rf /var/lib/mysql /tmp

RUN mkdir /var/run/redis && \
    rm /etc/redis/redis.conf && \
    usermod -a -G redis www-data
COPY redis.conf /etc/redis/redis.conf
RUN chmod 755 /etc/redis/redis.conf

ENV DBPASS=""

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/root/entrypoint.sh"]
