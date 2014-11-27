#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-nova-install:"
date

#Install nova components
apt-get install -y nova-common nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient

#Modify conf files
./controller-node-nova-modify-conf-files.sh

#Remove the SQLite database file
rm -f /var/lib/nova/nova.sqlite

if [ $FIRST_NOVA_NODE = 'Yes' ]; then
    echo "FIRST_NOVA_NODE = Yes"

    #Synchronize database
    nova-manage db sync
else
    echo "FIRST_NOVA_NODE = No"
fi

# DO NOT restart Service Nova when use multi controller nodes, it will make "nova-manage db sync" failed on first controller node.
# DO NOT restart Service Nova when use multi controller nodes, it will make "nova-manage db sync" failed on first controller node.
# DO NOT restart Service Nova when use multi controller nodes, it will make "nova-manage db sync" failed on first controller node.
# ./restart-service-nova-api.sh

#Show Service Status
./show-service-status-nova-api.sh

#

echo "End time of controller-node-nova-install:"
date

exit 0
