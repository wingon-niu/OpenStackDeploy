#!/bin/bash

source ./env.sh

MY_SERVICE_NAME=network

./make-creds.sh
source ./openrc

if [ $(keystone service-list | grep " $MY_SERVICE_NAME " | grep -v grep | wc -l) -eq 0 ]; then
    keystone service-create --name neutron --type network --description "OpenStack Networking"
    keystone endpoint-create \
        --service-id $(keystone service-list | awk '/ network / {print $2}') \
        --publicurl   http://$CONTROLLER_NODE_EXTERNAL_NET_IP:9696 \
        --adminurl    http://$CONTROLLER_NODE_MANAGEMENT_IP:9696 \
        --internalurl http://$CONTROLLER_NODE_MANAGEMENT_IP:9696
fi

exit 0
