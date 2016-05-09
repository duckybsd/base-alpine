#!/usr/bin/with-contenv sh

# Put env vars into /var/run/wodby/env
if [ ! -d /var/run/wodby ]; then
    mkdir -p /var/run/wodby
    chown $WODBY_USER:$WODBY_GROUP /var/run/wodby
fi

# Filter env vars and store
printenv | xargs -I{} echo {} | awk ' \
    BEGIN { FS = "=" }; { \
        if ($1 != "HOME" \
            && $1 != "PWD" \
            && $1 != "PATH" \
            && $1 != "SHLVL" \
            && $1 != "S6_LOGGING" \
            && $1 != "S6_LOGGING_SCRIPT") { \
            \
            print ""$1"="$2"" \
        } \
    }' > /var/run/wodby/env

chown $WODBY_USER:$WODBY_GROUP /var/run/wodby/env

# Generate env vars for sh profile
cat /var/run/wodby/env | xargs -I{} echo {} | awk 'BEGIN { FS = "=" }; { print "export "$1"="$2"" }' > /var/run/wodby/profile-env
chown $WODBY_USER:$WODBY_GROUP /var/run/wodby/profile-env
chmod +x /var/run/wodby/profile-env

# Replace env vars in confd templates
sed -i -e 's@${WODBY_NAMESPACE}@'"${WODBY_NAMESPACE}"'@' /etc/confd/conf.d/*.toml
sed -i -e 's@${WODBY_USER}@'"${WODBY_USER}"'@' /etc/confd/conf.d/*.toml
sed -i -e 's@${WODBY_GUID}@'"${WODBY_GUID}"'@' /etc/confd/conf.d/*.toml
sed -i -e 's@${WODBY_CONF}@'"${WODBY_CONF}"'@' /etc/confd/conf.d/*.toml
sed -i -e 's@${WODBY_APP_TYPE}@'"${WODBY_APP_TYPE}"'@' /etc/confd/conf.d/*.toml
sed -i -e 's@${WODBY_APP_VERSION}@'"${WODBY_APP_VERSION}"'@' /etc/confd/conf.d/*.toml
