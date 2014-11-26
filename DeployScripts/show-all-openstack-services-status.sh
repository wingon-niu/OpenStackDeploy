#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy

#

echo "Show all OpenStack services status on all Controller Nodes..."
for MY_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo "Connecting to controller node: $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./controller-node-show-all-openstack-services-status.sh;"
    echo "Done."
done

echo "Show all OpenStack services status on all Network Nodes..."
for MY_IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
    echo "Connecting to network node: $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./network-node-show-all-openstack-services-status.sh;"
    echo "Done."
done

echo "Show all OpenStack services status on all Compute Nodes..."
for MY_IP in $(cat $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt); do
    echo "Connecting to compute node: $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./compute-node-show-all-openstack-services-status.sh;"
    echo "Done."
done

#

exit 0
