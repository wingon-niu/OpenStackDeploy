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

#Start front nodes installation
echo $STR_BEGIN_FRONT_NODES_INSTALL

screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

for IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP haproxy-keepalived-node-install.sh $RUN_DATE-front-nodes-install-$IP.log
done

$CMD_PATH/check-screen-ended.sh
echo $STR_COMPLETE_FRONT_NODES_INSTALL

echo $STR_GET_LOG_FILE_FROM_SERVERS
for IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-front-nodes-install-$IP.log $CMD_PATH/log/
    sleep 1
    ssh root@$IP "shutdown -r now"
done

#

exit 0
