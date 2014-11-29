#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-neutron-install:"
date

#To install the Networking components
apt-get -y install neutron-common neutron-server neutron-plugin-ml2 python-neutronclient

#Modify conf files
$OPENSTACK_RELEASE/controller-node-neutron-modify-conf-files.sh

if [ $FIRST_NEUTRON_NODE = 'Yes' ]; then
    #Create Neutron Service and Endpoint if not exist
    ./create-neutron-service-endpoint.sh

    if [ "$OPENSTACK_RELEASE" = "." ]; then
        #Populate the database when use juno
        su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno" neutron
    fi
fi

#Accept udp port 4789 when use vxlan
if [ $TENANT_NETWORK_TYPES = 'vxlan' ]; then
    ./udp-port-4789-accept.sh
fi

#Restart Neutron
./restart-service-controller-node-neutron.sh

#Show Service Status
./show-service-status-controller-node-neutron.sh

#

echo "End time of controller-node-neutron-install:"
date

exit 0
