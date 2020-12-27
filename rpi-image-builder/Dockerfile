FROM debian:buster

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        qemu-user-static 
RUN apt-get install -yq --no-install-recommends \
    unzip zip

COPY *raspios*.zip /
RUN unzip *.zip && \
     rm *.zip

RUN apt-get install -yq --no-install-recommends \
    binfmt-support \
    dumb-init \
    qemu-utils \
    parted

COPY entrypoint.sh /
COPY rootcopy /rootcopy
ENTRYPOINT ["dumb-init", "bash", "entrypoint.sh"]