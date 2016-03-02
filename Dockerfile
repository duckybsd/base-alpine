# official base image: https://hub.docker.com/_/alpine/
FROM alpine:3.3
MAINTAINER Wodby <hello@wodby.com>

# global variables, will be available in any heritable images
ENV TERM="xterm-color" S6_LOGGING="1" S6_LOGGING_SCRIPT="n1 s10000000 T" WODBY_HOME="/srv" WODBY_OPT="/opt/wodby"
ENV WODBY_REPO="${WODBY_HOME}/repo" WODBY_FILES="${WODBY_HOME}/files" WODBY_BACKUPS="${WODBY_HOME}/backups" WODBY_LOGS="${WODBY_HOME}/logs" WODBY_CONF="${WODBY_HOME}/conf" WODBY_BIN="${WODBY_OPT}/bin"
ENV WODBY_STATIC="${WODBY_DOCROOT}/static" WODBY_BUILD="${WODBY_HOME}/.build" WODBY_DOCROOT="${WODBY_REPO}"

# define local variables first (to easy maintain in future)
RUN export S6_OVERLAY_VER=1.17.1.2 && \
# add wodby user and group, it must me elsewhere with the same uid/gid
# run any services which generate any forders/files from this user
    addgroup -S -g 41532 wodby && adduser -HS -u 41532 -h ${WODBY_HOME} -s /bin/sh -G wodby wodby && \
# fixed alpine bug when /etc/hosts isn't processed
    echo 'hosts: files dns' >> /etc/nsswitch.conf && \
# install ca certs to communicate external sites by SSL
# and rsync as we'ar using it to syncronize folders
    apk add --update ca-certificates rsync && \
# install s6-overlay (https://github.com/just-containers/s6-overlay)
    wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VER}/s6-overlay-amd64.tar.gz | tar xz -C / && \
# clear cache data and disable su
    rm -rf /var/cache/apk/* /tmp/* /usr/bin/su

# copy our scripts to the image
COPY rootfs /

# default entrypoint, never overright it
ENTRYPOINT ["/init"]