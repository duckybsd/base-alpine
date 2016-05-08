# Official base image: https://hub.docker.com/_/alpine/
FROM alpine:3.3
MAINTAINER Wodby <hello@wodby.com>

# Global variables, will be available in any heritable images
ENV TERM="xterm-color" \
    S6_LOGGING="1" \
    S6_LOGGING_SCRIPT="n1 s10000000 T" \

    WODBY_USER="wodby" \
    WODBY_GROUP="wodby" \
    WODBY_GUID="41532" \

    WODBY_OPT="/opt/wodby" \
    WODBY_BIN="${WODBY_OPT}/bin" \

    WODBY_HOME="/srv" \
    WODBY_FILES="${WODBY_HOME}/files" \
    WODBY_BACKUPS="${WODBY_HOME}/backups" \
    WODBY_LOGS="${WODBY_HOME}/logs" \
    WODBY_CONF="${WODBY_HOME}/conf"

RUN \

    # Install common packages
    apk add --update \
        busybox-suid \
        ca-certificates \
        rsync \
        nmap-ncat \
        pwgen \
        tar \
        less \
        && \

    # Fixed alpine bug when /etc/hosts isn't processed
    # http://bugs.alpinelinux.org/issues/4371
    # todo Review needed
    echo 'hosts: files dns' >> /etc/nsswitch.conf && \

    # Install s6-overlay
    # https://github.com/just-containers/s6-overlay
    wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz | tar xz -C / && \

    # Add wodby user and group, it must me elsewhere with the same uid/gid
    # Run any services which generate any forders/files from this user
    addgroup -S -g "${WODBY_GUID}" "${WODBY_GROUP}" && \
    adduser -HS -u "${WODBY_GUID}" -h "${WODBY_HOME}" -s /bin/bash -G "${WODBY_GROUP}" "${WODBY_USER}" && \

    # Disable su
    # todo Review needed
    rm -f /usr/bin/su && \

    # Final cleanup
    rm -rf /var/cache/apk/* /tmp/* /usr/share/man

COPY rootfs /

ENTRYPOINT ["/init"]
