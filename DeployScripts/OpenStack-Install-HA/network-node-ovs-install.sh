#!/bin/bash

cd /root/OpenStack-Install-HA
source ./env.sh

ifdown $EXTERNAL_NETWORK_INTERFACE_NAME
ovs-vsctl add-port br-ex $EXTERNAL_NETWORK_INTERFACE_NAME

./network-node-set-ip-for-br-ex.sh

ifup   $EXTERNAL_NETWORK_INTERFACE_NAME
ifconfig br-ex up
ifup br-ex

#

### Depending on your network interface driver, you may need to disable
### Generic Receive Offload (GRO) to achieve suitable throughput between
### your instances and the external network.
### To temporarily disable GRO on the external network interface while testing your environment:
#ethtool -K $EXTERNAL_NETWORK_INTERFACE_NAME gro off

#Restart Service Neutron
./restart-service-network-node-neutron.sh

#Show Service Status
./show-service-status-network-node-neutron.sh

#

echo "End time of network-node-neutron-install:"
date

#

exit 0
