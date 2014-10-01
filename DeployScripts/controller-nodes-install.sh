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

#Start controller nodes installation
echo $STR_BEGIN_CONTROLLER_NODES_INSTALL

#Get all controller nodes IPs
declare -a G_CONTROLLER_NODE_IPS
MY_INDEX=0
for IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    G_CONTROLLER_NODE_IPS[$MY_INDEX]=$IP
    ((MY_INDEX++))
done

#Process controller-node-install-part-1 on controller node 1
echo $CTL_INSTALL_PART_1_ON_CTL_1
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[0]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-1.sh $RUN_DATE-controller-node-install-part-1-$IP.log
$CMD_PATH/check-screen-ended.sh

#Process controller-node-install-part-1 on controller node 2
echo $CTL_INSTALL_PART_1_ON_CTL_2
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[1]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-1.sh $RUN_DATE-controller-node-install-part-1-$IP.log
$CMD_PATH/check-screen-ended.sh

#Process controller-node-install-part-1 on controller node 3
echo $CTL_INSTALL_PART_1_ON_CTL_3
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[2]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-1.sh $RUN_DATE-controller-node-install-part-1-$IP.log
$CMD_PATH/check-screen-ended.sh

#Sync /var/lib/rabbitmq/.erlang.cookie
rsync -va root@${G_CONTROLLER_NODE_IPS[0]}:/var/lib/rabbitmq/.erlang.cookie $CMD_PATH/.erlang.cookie
rsync -va $CMD_PATH/.erlang.cookie root@${G_CONTROLLER_NODE_IPS[1]}:/var/lib/rabbitmq/.erlang.cookie
rsync -va $CMD_PATH/.erlang.cookie root@${G_CONTROLLER_NODE_IPS[2]}:/var/lib/rabbitmq/.erlang.cookie

#Process controller-node-install-part-2 on controller node 1
echo $CTL_INSTALL_PART_2_ON_CTL_1
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[0]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-2.sh $RUN_DATE-controller-node-install-part-2-$IP.log
$CMD_PATH/check-screen-ended.sh

#Process controller-node-install-part-2 on controller node 2
echo $CTL_INSTALL_PART_2_ON_CTL_2
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[1]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-2.sh $RUN_DATE-controller-node-install-part-2-$IP.log
$CMD_PATH/check-screen-ended.sh

#Process controller-node-install-part-2 on controller node 3
echo $CTL_INSTALL_PART_2_ON_CTL_3
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
IP=${G_CONTROLLER_NODE_IPS[2]}
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-2.sh $RUN_DATE-controller-node-install-part-2-$IP.log
$CMD_PATH/check-screen-ended.sh

#Process controller-node-install-part-3 on all controller nodes
echo $CTL_INSTALL_PART_3_ON_ALL_CTL
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
for IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP controller-node-install-part-3.sh $RUN_DATE-controller-node-install-part-3-$IP.log
done
$CMD_PATH/check-screen-ended.sh

echo $STR_CONTROLLER_NODES_INSTALL_COMPLETED

echo $STR_GET_LOG_FILE_FROM_SERVERS
for IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-controller-node-install-part-1-$IP.log $CMD_PATH/log/
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-controller-node-install-part-2-$IP.log $CMD_PATH/log/
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-controller-node-install-part-3-$IP.log $CMD_PATH/log/
done

#

exit 0
