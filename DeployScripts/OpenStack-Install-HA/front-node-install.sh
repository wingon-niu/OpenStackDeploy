#!/bin/bash

source ./env.sh

echo "Begin time of front-node-install:"
date

#Prepare to install
apt-get install -y libssl-dev openssl libpopt-dev mailutils sharutils sendmail rsyslog

#Install HAproxy
./front-node-haproxy-install.sh

#Install Keepalived
if [ "$KEEPALIVED_INTERNAL_NET_INTERFACE_NAME" = "$KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME" ]; then
    echo "keepalived: 1 nic"
    ./front-node-keepalived-1-nic-install.sh
else
    echo "keepalived: 2 nic"
    ./front-node-keepalived-2-nic-install.sh
fi

#Stop keepalived and haproxy
/etc/init.d/keepalived stop
/etc/init.d/haproxy stop

#Start keepalived
#haproxy will be auto started after 5 seconds
/etc/init.d/keepalived start

#

echo "End time of front-node-install:"
date

exit 0
