#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-neutron-install:"
date

if [ $FIRST_NEUTRON_NODE = 'Yes' ]; then
    #Create Neutron Service and Endpoint if not exist
    ./create-neutron-service-endpoint.sh
fi

#To install the Networking components
apt-get -y install neutron-common neutron-server neutron-plugin-ml2

#Modify conf files
./controller-node-neutron-modify-conf-files.sh

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
