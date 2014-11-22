#!/bin/bash

source ./env.sh

#Add hostname and ip to /etc/hosts
CONF_FILE=/etc/hosts
./backup-file.sh $CONF_FILE

echo "#Used for message queue nodes."             >>    $CONF_FILE
echo "$MQ_NODE_01_IP  $MQ_NODE_01_HOST_NAME"      >>    $CONF_FILE
echo "$MQ_NODE_02_IP  $MQ_NODE_02_HOST_NAME"      >>    $CONF_FILE
echo "$MQ_NODE_03_IP  $MQ_NODE_03_HOST_NAME"      >>    $CONF_FILE

#

exit 0
