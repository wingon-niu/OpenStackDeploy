#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
RUN_DATE=$1
source ./locale_en.txt

#

if [ ! -d $CONF_DEPLOY_DIR                          -o \
     ! -f $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt      -o \
     ! -f $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt -o \
     ! -f $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt    -o \
     ! -f $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt      \
   ]; then

    echo "Error: Info files needed for undeploy not exist! Can not undeploy."
    exit 1

fi

echo "Begin undeploy OpenStack Cluster..."

#If used neutron on network nodes, need to unconfigure ovs networking on network nodes first.
HISTROY_FILE=action-prefix-history.txt
MY_PREFIX=$(tail -n 1 $CONF_DEPLOY_DIR/$HISTROY_FILE | awk -F',' '{print $7}')
MY_NETWORK_API_CLASS=$($CMD_PATH/get-conf-data.sh $DST_PATH/$MY_PREFIX-Network-Conf.txt Network-api-class)
if [ "$MY_NETWORK_API_CLASS" = "neutron" ]; then
    echo "Network nodes used neutron, need to unconfigure ovs networking on network nodes first..."
    echo $STR_PING_ALL_SERVERS
    $CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt 10
    for MY_IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
        echo "Connecting to $MY_IP"
        ssh root@$MY_IP "nohup /root/OpenStack-Install-HA/network-node-ovs-uninstall.sh > /root/OpenStack-Install-HA/log/network-node-ovs-uninstall.log 2>&1 &"
        echo "Done."
    done
fi

echo "Undeploying Computer Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt); do
    echo "Connecting to $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./compute-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-compute-node-uninstall.log;"
done

echo "Undeploying Network Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
    echo "Connecting to $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./network-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-network-node-uninstall.log;"
done

echo "Undeploying Controller Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo "Connecting to $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./controller-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-controller-node-uninstall.log;"
done

echo "Undeploying Front Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    echo "Connecting to $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./front-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-front-node-uninstall.log;"
done

#If used ceph, undeploy ceph cluster.

#Delete host info in /etc/hosts on controller nodes.

#

exit 0
