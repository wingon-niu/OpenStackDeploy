#!/bin/bash

source ./env.sh

echo "Begin time of compute-node-neutron-install:"
date

#Enable certain kernel networking functions
CONF_FILE=/etc/sysctl.conf
./backup-file.sh $CONF_FILE

sed -i '/^net.ipv4.conf.all.rp_filter=/d'     $CONF_FILE
sed -i '/^net.ipv4.conf.default.rp_filter=/d' $CONF_FILE
echo "net.ipv4.conf.all.rp_filter=0"       >> $CONF_FILE
echo "net.ipv4.conf.default.rp_filter=0"   >> $CONF_FILE

sysctl -p

#To install the Networking components
apt-get -y install neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent

#Modify conf files
./compute-node-neutron-modify-conf-files.sh

#Accept udp port 4789 when use vxlan
if [ $TENANT_NETWORK_TYPES = 'vxlan' ]; then
    ./udp-port-4789-accept.sh
fi

#To configure the Open vSwitch (OVS) service
service openvswitch-switch restart
ovs-vsctl add-br br-int

#Restart all the services
./restart-service-compute-node-neutron.sh

#Show Service Status
./show-service-status-compute-node-neutron.sh

#

echo "End time of compute-node-neutron-install:"
date

exit 0
