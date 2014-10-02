#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-part-3-install:"
date

#Install Keystone
./keystone-install.sh

#Install Glance
./glance-install.sh

#Install Cinder
./cinder-install.sh

#Install Nova
./controller-node-nova-install.sh

if [ $NETWORK_API_CLASS = 'neutron' ]; then
    echo "NETWORK_API_CLASS = neutron"

    #Install Neutron
    ./controller-node-neutron-install.sh

elif [ $NETWORK_API_CLASS = 'nova-network' ]; then
    echo "NETWORK_API_CLASS = nova-network"
else
    echo "NETWORK_API_CLASS = unknown type"
fi

#Install Horizon
./horizon-install.sh

#

echo "End time of controller-node-part-3-install:"
date

exit 0
