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

#Make backend nodes IPs
rm -f $CONF_DEPLOY_DIR/Backend-Nodes-IPs.txt
cp $CONF_DEPLOY_DIR/Servers-IPs.txt $CONF_DEPLOY_DIR/Backend-Nodes-IPs.txt
for IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    sed -i "/$IP/d" $CONF_DEPLOY_DIR/Backend-Nodes-IPs.txt
done

#Start prepare all servers
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

for IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node-reboot.expect $IP node-prepare-front-node.sh   $RUN_DATE-prepare-front-node-$IP.log
done

for IP in $(cat $CONF_DEPLOY_DIR/Backend-Nodes-IPs.txt); do
    screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node-reboot.expect $IP node-prepare-backend-node.sh $RUN_DATE-prepare-backend-node-$IP.log
done

$CMD_PATH/check-screen-ended.sh
echo $STR_ALL_SERVERS_REBOOTED

echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Servers-IPs.txt 30

echo $STR_GET_LOG_FILE_FROM_SERVERS

for IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-prepare-front-node-$IP.log   $CMD_PATH/log/
done

for IP in $(cat $CONF_DEPLOY_DIR/Backend-Nodes-IPs.txt); do
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-prepare-backend-node-$IP.log $CMD_PATH/log/
done

#

exit 0
