#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-nova-install:"
date

#Install nova components
apt-get install -y nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient

rm /var/lib/nova/nova.sqlite

#Modify conf files
./controller-node-nova-modify-conf-files.sh

if [ $FIRST_NOVA_NODE = 'Yes' ]; then
    echo "FIRST_NOVA_NODE = Yes"

    #Synchronize database
    nova-manage db sync
else
    echo "FIRST_NOVA_NODE = No"
fi

#Restart Service Nova
./restart-service-nova-api.sh

#Show Service Status
./show-service-status-nova-api.sh

#

echo "End time of controller-node-nova-install:"
date

exit 0
