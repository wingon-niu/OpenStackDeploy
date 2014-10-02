#!/bin/bash

source ./env.sh

./make-creds.sh
source ./openrc



EXT_NET_NAME=ext-net-1
EXT_SUBNET_NAME=ext-subnet-1

INT_NET_NAME=int-net-1
INT_SUBNET_NAME=int-subnet-1

ROUTER_NAME=router-1



EXT_NET_ID=$(neutron net-create $EXT_NET_NAME --router:external=True | awk '/ id / {print $4}')

EXT_SUBNET_ID=$(neutron subnet-create $EXT_NET_NAME $NEUTRON_EXT_NET_CIDR --name $EXT_SUBNET_NAME --gateway $NEUTRON_EXT_NET_GATEWAY --allocation-pool start=$NEUTRON_EXT_NET_IP_POOL_START,end=$NEUTRON_EXT_NET_IP_POOL_END --dns-nameserver $NEUTRON_DNS_NAMESERVER_2 --dns-nameserver $NEUTRON_DNS_NAMESERVER_1 --disable-dhcp | awk '/ id / {print $4}')

INT_NET_ID=$(neutron net-create $INT_NET_NAME | awk '/ id / {print $4}')

INT_SUBNET_ID=$(neutron subnet-create $INT_NET_NAME $NEUTRON_INT_NET_CIDR --name $INT_SUBNET_NAME --gateway $NEUTRON_INT_NET_GATEWAY --allocation-pool start=$NEUTRON_INT_NET_IP_POOL_START,end=$NEUTRON_INT_NET_IP_POOL_END --dns-nameserver $NEUTRON_DNS_NAMESERVER_2 --dns-nameserver $NEUTRON_DNS_NAMESERVER_1 | awk '/ id / {print $4}')

ROUTER_ID=$(neutron router-create $ROUTER_NAME | awk '/ id / {print $4}')

neutron router-interface-add $ROUTER_ID $INT_SUBNET_ID

neutron router-gateway-set $ROUTER_ID $EXT_NET_ID

echo ""
echo "Done."
echo ""

exit 0
