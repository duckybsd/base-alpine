FROM alpine:edge
MAINTAINER Wodby <hello@wodby.com>

# global variables, will be available in any heritable images
ENV TERM="xterm-color" WODBY_USER="wodby" WODBY_GROUP="wodby" WODBY_GUID="41532" WODBY_HOME="/srv" WODBY_OPT="/opt/wodby"
ENV WODBY_REPO="${WODBY_HOME}/repo" WODBY_FILES="${WODBY_HOME}/files" WODBY_BACKUPS="${WODBY_HOME}/backups" WODBY_LOGS="${WODBY_HOME}/logs" WODBY_CONF="${WODBY_HOME}/conf"
ENV WODBY_BUILD="${WODBY_HOME}/.build" WODBY_DOCROOT="${WODBY_REPO}" WODBY_BIN="${WODBY_OPT}/bin"
ENV WODBY_STATIC="${WODBY_DOCROOT}/static"

# define local variables first (to easy maintain in future)
RUN export S6_OVERLAY_VER=1.17.2.0 && \
# add wodby user and group, it must me elsewhere with the same uid/gid
# run any services which generate any forders/files from this user
    addgroup -S -g "${WODBY_GUID}" "${WODBY_GROUP}" && adduser -HS -u "${WODBY_GUID}" -h "${WODBY_HOME}" -s /bin/bash -G "${WODBY_GROUP}" "${WODBY_USER}" && \
# generate random password for wodby user
    pass=$(pwgen -s 24 1) echo -e "${pass}\n${pass}\n" | passwd wodby && \
# fixed alpine bug when /etc/hosts isn't processed
    echo 'hosts: files dns' >> /etc/nsswitch.conf && \
# install ca certs to communicate external sites by SSL
# and rsync as we'ar using it to syncronize folders
# and bush as a lot of customers like it
    apk add --update libressl ca-certificates rsync bash curl wget nmap-ncat busybox-suid less grep sed tar gzip && \
# install s6-overlay (https://github.com/just-containers/s6-overlay)
    wget -qO- https://s3.amazonaws.com/wodby-releases/s6-overlay/v${S6_OVERLAY_VER}/s6-overlay-amd64.tar.gz | tar xz -C / && \
# clear cache data and disable su
    rm -rf /var/cache/apk/* /tmp/* /usr/bin/su

# copy our scripts to the image
COPY rootfs /

# default entrypoint, never overright it
ENTRYPOINT ["/init"]
