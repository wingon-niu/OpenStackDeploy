#!/bin/bash

source ./env.sh

echo "Begin time of compute-node-install:"
date

#Install QEMU
#./compute-node-qemu-install.sh

#Install KVM
#./compute-node-kvm-install.sh

#Install OpenVSwitch
#./compute-node-openvswitch-install.sh

#Install Nova
./compute-node-nova-install.sh

if [ $NETWORK_API_CLASS = 'neutron' ]; then
    echo "NETWORK_API_CLASS = neutron"

    #Install Neutron
    ./compute-node-neutron-install.sh

elif [ $NETWORK_API_CLASS = 'nova-network' ]; then
    echo "NETWORK_API_CLASS = nova-network"
else
    echo "NETWORK_API_CLASS = unknown type"
fi

#

echo "End time of compute-node-install:"
date

exit 0
