FROM alpine:latest

ENV ROOT_PASSWORD root
RUN apk --no-cache add openssh rsync \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && echo "root:${ROOT_PASSWORD}" | chpasswd \
    && rm -rf /var/cache/apk/* /tmp/*

COPY entrypoint.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]
