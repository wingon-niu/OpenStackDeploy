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

#Run post installation scripts on first controller node
echo $STR_RUN_POST_INSTALL_SCRIPT

screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

IP=$(head -n 1 $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt)
screen   -S niu -U -X screen   -U -t $IP $CMD_PATH/run-on-node.expect $IP post-install-script.sh $RUN_DATE-post-install-script-$IP.log

$CMD_PATH/check-screen-ended.sh
echo $STR_COMPLETE_POST_INSTALL_SCRIPT

echo $STR_GET_LOG_FILE_FROM_SERVERS
IP=$(head -n 1 $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt)
rsync -va $IP:/root/OpenStack-Install-HA/log/$RUN_DATE-post-install-script-$IP.log $CMD_PATH/log/

#

exit 0
