#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running compute node uninstall on $MY_HOST_NAME"

#

./stop-service-nova-compute.sh
./stop-service-nova-network.sh
./stop-service-compute-node-neutron.sh
service openvswitch-switch stop

#

apt-get -y     remove openvswitch-switch neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent
apt-get -y autoremove openvswitch-switch neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent --purge

#

rm -rf /var/log/neutron
rm -rf /var/lib/neutron
rm -rf /etc/neutron
rm -rf /var/log/openvswitch

#

exit 0
