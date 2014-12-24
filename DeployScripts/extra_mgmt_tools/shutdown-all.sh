#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
RUN_DATE=$(date "+%Y-%m-%d-%H-%M-%S")

source ./locale_en.txt

echo "Shutting down all Nodes..."
#$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Servers-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Servers-IPs.txt); do
    echo "Connecting to node: $MY_IP"
#   ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./compute-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-compute-node-uninstall.log;"
    $CMD_PATH/run-on-node-shutdown.except $MY_IP $RUN_DATE-shutdown-all-nodes.log
done


