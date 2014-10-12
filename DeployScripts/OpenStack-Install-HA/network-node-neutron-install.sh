#!/bin/bash

source ./env.sh

echo "Begin time of network-node-neutron-install:"
date

#Enable certain kernel networking functions
CONF_FILE=/etc/sysctl.conf
./backup-file.sh $CONF_FILE

sed -i '/^net.ipv4.ip_forward=/d'             $CONF_FILE
sed -i '/^net.ipv4.conf.all.rp_filter=/d'     $CONF_FILE
sed -i '/^net.ipv4.conf.default.rp_filter=/d' $CONF_FILE
echo "net.ipv4.ip_forward=1"               >> $CONF_FILE
echo "net.ipv4.conf.all.rp_filter=0"       >> $CONF_FILE
echo "net.ipv4.conf.default.rp_filter=0"   >> $CONF_FILE

sysctl -p

#To install the Networking components
apt-get -y install neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent

#Modify conf files
./network-node-neutron-modify-conf-files.sh

#Accept udp port 4789 when use vxlan
if [ $TENANT_NETWORK_TYPES = 'vxlan' ]; then
    ./udp-port-4789-accept.sh
fi

#To configure the Open vSwitch (OVS) service
service openvswitch-switch restart
ovs-vsctl add-br br-int
ovs-vsctl add-br br-ex
./network-node-set-ip-for-br-ex.sh
sleep 5
ovs-vsctl add-port br-ex $EXTERNAL_NETWORK_INTERFACE_NAME;shutdown -r now;

### Depending on your network interface driver, you may need to disable
### Generic Receive Offload (GRO) to achieve suitable throughput between
### your instances and the external network.
### To temporarily disable GRO on the external network interface while testing your environment:
#ethtool -K $EXTERNAL_NETWORK_INTERFACE_NAME gro off

#Restart Service Neutron
#./restart-service-network-node-neutron.sh

#Show Service Status
#./show-service-status-network-node-neutron.sh

#

#echo "End time of network-node-neutron-install:"
#date

#exit 0
