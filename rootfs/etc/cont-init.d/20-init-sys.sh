#!/usr/bin/with-contenv sh

mkdir -p /opt/bin
ln -s /usr/bin/with-contenv /opt/bin/sh

ns_srv=$(grep -m1 '^nameserver' /etc/resolv.conf)
ns_other=$(grep -Ev '^#|^nameserver' /etc/resolv.conf)
printf '%s\n%s\n' "${ns_srv}" "${ns_other}" > /etc/resolv.conf
