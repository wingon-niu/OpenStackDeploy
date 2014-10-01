#!/bin/bash

DST_PATH=$1
FILE_NAME=$2
SERVER_NAME=$3
NIC_NAME=$4
CMD_PATH=.

SERVER_NIC_NAME=$(cat $DST_PATH/$FILE_NAME | grep $SERVER_NAME | grep $NIC_NAME | awk -F'=' '{print $1}')
SERVER_NIC_IP=${SERVER_NIC_NAME/name/ip}

$CMD_PATH/get-conf-data.sh $DST_PATH/$FILE_NAME $SERVER_NIC_IP

exit 0
