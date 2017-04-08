FROM debian:jessie

RUN apt-get update && apt-get install easy-rsa -y

RUN mkdir -p /etc/openvpn
RUN cp -r /usr/share/easy-rsa/ /etc/openvpn
COPY vars /usr/share/easy-rsa/vars
RUN openssl dhparam -out /etc/openvpn/dh4096.pem 4096
