FROM debian:stretch-slim
#FROM armhf/debian:jessie

#Lets encrypt
#RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee /etc/apt/sources.list.d/backports.list
RUN apt-get update && apt-get install -y \  
    python-certbot

EXPOSE 80 443

CMD ["/bin/bash", "-x", "/tmp/entrypoint.sh"] 
