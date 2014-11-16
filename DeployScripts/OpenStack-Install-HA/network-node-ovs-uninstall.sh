#!/bin/bash

cd /root/OpenStack-Install-HA
source ./env.sh

ifconfig br-ex down
ifconfig $EXTERNAL_NETWORK_INTERFACE_NAME down
ovs-vsctl del-port br-ex $EXTERNAL_NETWORK_INTERFACE_NAME

./network-node-unset-ip-for-br-ex.sh

ifdown $EXTERNAL_NETWORK_INTERFACE_NAME
ifup   $EXTERNAL_NETWORK_INTERFACE_NAME

#

exit 0
