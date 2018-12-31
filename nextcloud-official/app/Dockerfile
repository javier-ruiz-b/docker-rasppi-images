FROM nextcloud:fpm

COPY redis.config.php /usr/src/nextcloud/config/redis.config.php
RUN echo "upload_max_filesize=16G" > /usr/local/etc/php/conf.d/upload-filesize.ini
RUN echo "post_max_size=16G" >> /usr/local/etc/php/conf.d/upload-filesize.ini
