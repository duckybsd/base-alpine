#!/usr/bin/with-contenv sh

# Create home dir for dev reason only.
# In the normal case, the dir is must be mounted from the host machine
if [ ! -d $WODBY_HOME ]; then
    mkdir $WODBY_HOME
fi

# Fix permissions
chown $WODBY_USER:$WODBY_GROUP $WODBY_HOME

if [ ! -d $WODBY_CONF ]; then
    mkdir $WODBY_HOME/.ssh
    chown $WODBY_USER:$WODBY_GROUP $WODBY_HOME/.ssh
    chmod 700 $WODBY_HOME/.ssh
fi

if [ ! -f $WODBY_HOME/.profile ]; then
    echo -e 'alias ls="ls --color"' >> $WODBY_HOME/.profile
    echo -e 'alias ll="ls -lah --color"' >> $WODBY_HOME/.profile
    echo -e '. /var/run/wodby/profile-env' >> $WODBY_HOME/.profile
    chown $WODBY_USER:$WODBY_GROUP $WODBY_HOME/.profile
fi

if [ ! -d $WODBY_CONF ]; then
    mkdir $WODBY_CONF
    chown $WODBY_USER:$WODBY_GROUP $WODBY_CONF
fi

if [ ! -d $WODBY_LOGS ]; then
    mkdir $WODBY_LOGS
    chown $WODBY_USER:$WODBY_GROUP $WODBY_LOGS
fi

if [ ! -d $WODBY_FILES ]; then
    mkdir $WODBY_FILES
    mkdir $WODBY_FILES/public
    mkdir $WODBY_FILES/private
    chown -R $WODBY_USER:$WODBY_GROUP $WODBY_FILES
fi

# Do not create backup directory, because it must be mounted from the host machine
if [ -d $WODBY_BACKUPS ]; then
    chown $WODBY_USER:$WODBY_GROUP $WODBY_BACKUPS
fi

if [ ! -d $WODBY_HOME/.wodby/locks ]; then
    mkdir -p $WODBY_HOME/.wodby/locks
    chown -R $WODBY_USER:$WODBY_GROUP $WODBY_HOME/.wodby
fi
