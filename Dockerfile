# official base image: https://hub.docker.com/_/alpine/
FROM alpine:3.2
MAINTAINER Ivan Gaas <ivan.gaas@gmail.com>

# global variables
ENV TERM="xterm" WODBY_HOME="/srv" WODBY_DOCROOT="${WODBY_HOME}/docroot"

# define local variables first (to easy maintain in future)
RUN export S6_OVERLAY_VER=1.16.0.0 && \
# add wodby user and group, it must me elsewhere with the same uid/gid
    addgroup -S -g 1001 wodby && adduser -HS -u 1001 -h /srv -s /bin/sh -G wodby wodby && \
# install ca certs to communicate external sites by ssl
    apk add --update ca-certificates && \
# install s6-overlay to the system
    wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VER}/s6-overlay-amd64.tar.gz | tar xz -C / && \
# clear cache data and disable su
    rm -rf /var/cache/apk/* /tmp/* /usr/bin/su

# default entrypoint
ENTRYPOINT ["/init"]