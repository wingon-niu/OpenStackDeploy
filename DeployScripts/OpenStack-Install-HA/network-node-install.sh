#!/bin/bash

source ./env.sh

echo "Begin time of network-node-install:"
date

#Install OpenVSwitch-1
#./network-node-openvswitch-1-install.sh

#Install OpenVSwitch-2
#./network-node-openvswitch-2-install.sh

if [ $NETWORK_API_CLASS = 'nova-network' ]; then

    echo "NETWORK_API_CLASS = nova-network"

    #Install nova-network
    ./network-node-nova-network-install.sh

elif [ $NETWORK_API_CLASS = 'neutron' ]; then

    echo "NETWORK_API_CLASS = neutron"

    #Install Neutron
    ./network-node-neutron-install.sh

else
    echo "NETWORK_API_CLASS = unknown type"
fi

#

echo "End time of network-node-install:"
date

exit 0
