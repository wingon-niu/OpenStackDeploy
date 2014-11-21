#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running front node uninstall on $MY_HOST_NAME"

#

/etc/init.d/keepalived stop
/etc/init.d/haproxy    stop

apt-get -y remove     haproxy keepalived
apt-get -y autoremove haproxy keepalived --purge

#

exit 0
