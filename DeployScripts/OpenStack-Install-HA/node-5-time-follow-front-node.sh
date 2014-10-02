#!/bin/bash

source ./env.sh

#Configure the NTP server to follow the front node

./backup-file.sh /etc/ntp.conf

sed -i 's/^server 0.ubuntu.pool.ntp.org/#server 0.ubuntu.pool.ntp.org/g'    /etc/ntp.conf
sed -i 's/^server 1.ubuntu.pool.ntp.org/#server 1.ubuntu.pool.ntp.org/g'    /etc/ntp.conf
sed -i 's/^server 2.ubuntu.pool.ntp.org/#server 2.ubuntu.pool.ntp.org/g'    /etc/ntp.conf
sed -i 's/^server 3.ubuntu.pool.ntp.org/#server 3.ubuntu.pool.ntp.org/g'    /etc/ntp.conf

sed -i "/^server /c server $CONTROLLER_NODE_MANAGEMENT_IP"                  /etc/ntp.conf

service ntp restart

exit 0
