#!/bin/bash

source ./env.sh

./make-creds.sh
source ./openrc

if [ $NETWORK_API_CLASS = 'nova-network' ]; then
    echo "NETWORK_API_CLASS = nova-network"

    echo "Delete service and endpoint: <network>"
    ./delete-keystone-service-endpoint.sh network

    if [ $NETWORK_MANAGER = 'FlatDHCPManager' ]; then
        echo "NETWORK_MANAGER = FlatDHCPManager"

        nova network-create fixed-network-1 --bridge $FLAT_NETWORK_BRIDGE --multi-host T --fixed-range-v4 $FIXED_RANGE_V4 --dns1 $MY_DNS1 --dns2 $MY_DNS2
        ./floating-ip-bulk-create.sh

        #
    elif [ $NETWORK_MANAGER = 'VlanManager' ]; then
        echo "NETWORK_MANAGER = VlanManager"

        MY_PROJECT_ID=$(keystone tenant-list | grep ' admin ' | grep -v grep | awk '{print $2}')
        nova-manage network create --label private-net-1 --fixed_range_v4 $FIXED_RANGE_V4 --num_networks $NUM_NETWORKS --network_size $NETWORK_SIZE --vlan $VLAN_START --bridge br$VLAN_START --bridge_interface $VLAN_INTERFACE --multi_host T --project_id $MY_PROJECT_ID --dns1 $MY_DNS1 --dns2 $MY_DNS2
        ./floating-ip-bulk-create.sh

        #
    else
        echo "NETWORK_MANAGER = unknown type"
    fi
elif [ $NETWORK_API_CLASS = 'neutron' ]; then
    echo "NETWORK_API_CLASS = neutron"

    ./create-admin-test-net.sh

    #
else
    echo "NETWORK_API_CLASS = unknown type"
fi

#If use ceph
if [ "$GLANCE_STORAGE" = "ceph" -o "$CINDER_STORAGE" = "ceph" ]; then
    echo "Use ceph block devices"
    echo "Upload image"
    glance image-create --name cirros-0.3.2.raw   --is-public true --container-format bare --disk-format raw   < ./images/cirros-0.3.2-x86_64-disk.raw
    echo "Wait 5 seconds..."
    sleep 5
    MY_IMAGE_ID=$(glance image-list | grep "cirros-0.3.2.raw" | awk '{print $2}' | head -n 1)
    echo "Create volume"
    cinder create --image-id $MY_IMAGE_ID --display-name cirros-0.3.2.volume 10
else
    echo "Use local disk"
    echo "Upload image"
    glance image-create --name cirros-0.3.2.qcow2 --is-public true --container-format bare --disk-format qcow2 < ./images/cirros-0.3.2-x86_64-disk.img
fi

echo "Add common secgroup rules"
nova secgroup-add-rule default icmp -1   -1   0.0.0.0/0
nova secgroup-add-rule default tcp  22   22   0.0.0.0/0
nova secgroup-add-rule default tcp  80   80   0.0.0.0/0
nova secgroup-add-rule default tcp  3389 3389 0.0.0.0/0

exit 0
