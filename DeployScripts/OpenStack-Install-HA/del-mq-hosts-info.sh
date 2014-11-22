#!/bin/bash

source ./env.sh

#Del hostname and ip in /etc/hosts
CONF_FILE=/etc/hosts
./backup-file.sh $CONF_FILE

sed -i "/#Used for message queue nodes./d"         $CONF_FILE
sed -i "/$MQ_NODE_01_IP  $MQ_NODE_01_HOST_NAME/d"  $CONF_FILE
sed -i "/$MQ_NODE_02_IP  $MQ_NODE_02_HOST_NAME/d"  $CONF_FILE
sed -i "/$MQ_NODE_03_IP  $MQ_NODE_03_HOST_NAME/d"  $CONF_FILE

#

exit 0
