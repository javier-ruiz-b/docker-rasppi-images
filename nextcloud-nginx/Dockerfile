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

WORKDIR /tmp

# Get nextcloud
RUN wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2 2> /dev/null \
    && wget --no-check-certificate https://download.nextcloud.com/server/releases/latest-11.tar.bz2.sha512 2> /dev/null \
    && shasum -a 512 - < latest-11.tar.bz2.sha512 < latest-11.tar.bz2 \
    && mkdir -p /var/www \
    && tar xfj latest-11.tar.bz2 -C /var/www \
    && rm latest-11.tar.bz2*

# Compile and install PHP7 from source
RUN apt-get update -qq && apt-get install -t jessie-backports -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    git \
    libfcgi-dev \
    libfcgi0ldbl \
    libjpeg62-turbo-dbg \
    libmcrypt4 \
    libmcrypt-dev \
    libc-client2007e \ 
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libiconv-hook1 \
    libiconv-hook-dev \
    libgmp10 \
    libgmp-dev \
    libicu52 \
    libicu-dev \
    libldb1 \
    libldb-dev \
    libldap-2.4-2 \
    libldap2-dev \
    libjpeg-dev \
    libpng12-dev \
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
    re2c \
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
    && chmod +x ./buildconf

RUN cd php-src && ./buildconf && ./configure CFLAGS='-O2' CXXFLAGS='-O2' --prefix=/ --with-zlib-dir --with-freetype-dir --enable-mbstring --with-libxml-dir=/usr --enable-soap --enable-calendar --with-curl --with-mcrypt --with-zlib --with-gd --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash --enable-zip --enable-intl --with-pcre-regex --with-mysqli --with-pdo-mysql --with-jpeg-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --with-openssl --with-fpm-user=www-data --with-fpm-group=www-data --enable-ftp --with-imap --with-imap-ssl --with-kerberos --with-gettext --with-xmlrpc --with-xsl --with-iconv --with-ldap=/usr --with-imap --with-gmp --enable-opcache --enable-ftp --enable-posix --enable-fpm \
    && make -j2 \
    && make install \
    && apt-get purge -y \
    autoconf \
    bison \
    build-essential \
    git \
    libfcgi-dev \
    libmcrypt-dev \
    libc-client2007e-dev \
    libxml2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    libiconv-hook-dev \
    libjpeg-dev \
    libgmp-dev \
    libicu-dev \
    libldap2-dev \
    libldb-dev \
    libpng12-dev \
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
    && sed -i 's/www-data/nginx/' /etc/php-fpm.d/www.conf \
    && echo 'env[HOSTNAME] = $HOSTNAME' >> /etc/php-fpm.d/www.conf \
    && echo 'env[PATH] = /usr/local/bin:/usr/bin:/bin' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TMP] = /tmp' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TMPDIR] = /tmp' >> /etc/php-fpm.d/www.conf \
    && echo 'env[TEMP] = /tmp' >> /etc/php-fpm.d/www.conf \
    && useradd nginx \
    && mkdir -p /var/lib/php/session \
    && chown nginx:nginx -R /var/lib/php/session/ \     
    && apt-get autoremove -y

ENV PATH=$PATH:/opt/php-7.1/bin

COPY init.d-php-7.1-fpm /etc/init.d/php-7.1-fpm
COPY install.sh /tmp/
RUN /bin/bash -x ./install.sh
COPY entrypoint.sh /tmp/
RUN rm /etc/nginx/sites-enabled/default
COPY nextcloud-nginx.conf /etc/nginx/sites-enabled/nextcloud

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/tmp/entrypoint.sh"] 
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
