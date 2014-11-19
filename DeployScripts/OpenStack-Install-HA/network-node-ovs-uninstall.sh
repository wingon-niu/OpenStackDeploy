#!/bin/bash

MY_HOST_NAME=$(hostname)
echo "Now running network-node-ovs-uninstall on $MY_HOST_NAME"

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
