#!/usr/bin/with-contenv sh

# Generate password for Wodby user
pass=$(pwgen -s 24 1) echo -e "${pass}\n${pass}\n" | passwd $WODBY_USER
