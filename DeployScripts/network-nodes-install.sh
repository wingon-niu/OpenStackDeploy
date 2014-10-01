#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
RUN_DATE=$1
MY_LOCALE=$($CMD_PATH/get-conf-data.sh ./locale.txt LOCALE)
if [ $MY_LOCALE = 'CN' ]; then
    source ./locale_cn.txt
else
    source ./locale_en.txt
fi

#Start network nodes installation
echo $STR_BEGIN_NETWORK_NODES_INSTALL

#Set command by nova-network or neutron
PREFIX_NETWORK_CONF=$($CMD_PATH/get-max-prefix.sh $DST_PATH Network-Conf.txt)
MY_NETWORK_API_CLASS=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Network-api-class)
if [ $MY_NETWORK_API_CLASS = 'neutron' ]; then
    echo "Network-api-class = neutron"
    echo "All network nodes will auto reboot after installation."
    MY_COMMAND=run-on-node-reboot.expect
else
    echo "Network-api-class = nova-network"
    MY_COMMAND=run-on-node.expect
fi

screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

for IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
    screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/$MY_COMMAND $IP network-node-install.sh $RUN_DATE-network-node-install-$IP.log
done

$CMD_PATH/check-screen-ended.sh
echo $STR_COMPLETE_NETWORK_NODES_INSTALL
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt 30

echo $STR_GET_LOG_FILE_FROM_SERVERS
for IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-network-node-install-$IP.log $CMD_PATH/log/
done

#

exit 0
