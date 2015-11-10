# official base image: https://hub.docker.com/_/alpine/
FROM alpine:3.2
MAINTAINER Ivan Gaas <ivan.gaas@gmail.com>

# global variables
ENV TERM="xterm-color" S6_LOGGING="1" S6_LOGGING_SCRIPT="n1 s10000000 T" WODBY_HOME="/srv"
ENV WODBY_DOCROOT="${WODBY_HOME}/docroot" WODBY_FILES="${WODBY_HOME}/files" WODBY_BACKUPS="${WODBY_HOME}/backups" WODBY_LOGS="${WODBY_HOME}/logs" WODBY_CONF="${WODBY_HOME}/conf" WODBY_REPO="${WODBY_HOME}/.repo"
ENV WODBY_STATIC="${WODBY_DOCROOT}/static"

# define local variables first (to easy maintain in future)
RUN export S6_OVERLAY_VER=1.16.0.0 && \
# add wodby user and group, it must me elsewhere with the same uid/gid
    addgroup -S -g 1001 wodby && adduser -HS -u 1001 -h ${WODBY_HOME} -s /bin/sh -G wodby wodby && \
# fixed alpine bug when /etc/hosts isn't processed
    echo 'hosts: files dns' >> /etc/nsswitch.conf && \
# install ca certs to communicate external sites by ssl
    apk add --update ca-certificates && \
# install s6-overlay (https://github.com/just-containers/s6-overlay) to the system
    wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VER}/s6-overlay-amd64.tar.gz | tar xz -C / && \
# clear cache data and disable su
    rm -rf /var/cache/apk/* /tmp/* /usr/bin/su

# copy our scripts to the image
COPY rootfs /

# default entrypoint
ENTRYPOINT ["/init"]