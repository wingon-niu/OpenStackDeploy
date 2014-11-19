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

#

exit 0
