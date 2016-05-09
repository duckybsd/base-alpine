#!/usr/bin/with-contenv sh

# Delete useless repo dir
if [ -d $WODBY_HOME/repo ]; then
    rm -rf $WODBY_HOME/repo
fi

# Delete old style .profile
if [ -f $WODBY_HOME/.profile ] && [ $( grep -ic "/var/run/wodby/profile-env" $WODBY_HOME/.profile ) -eq 0 ]; then
    rm $WODBY_HOME/.profile
fi
