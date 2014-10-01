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

##########################################################################################
PREFIX_SERVERS=$($CMD_PATH/get-max-prefix.sh          $DST_PATH Servers.txt)
PREFIX_SERVER_INFO=$($CMD_PATH/get-max-prefix.sh      $DST_PATH Server-Info.txt)
PREFIX_FRONT_NODES=$($CMD_PATH/get-max-prefix.sh      $DST_PATH Front-Nodes.txt)
PREFIX_CONTROLLER_NODES=$($CMD_PATH/get-max-prefix.sh $DST_PATH Controller-Nodes.txt)
PREFIX_NETWORK_NODES=$($CMD_PATH/get-max-prefix.sh    $DST_PATH Network-Nodes.txt)
PREFIX_COMPUTER_NODES=$($CMD_PATH/get-max-prefix.sh   $DST_PATH Computer-Nodes.txt)
PREFIX_NETWORK_CONF=$($CMD_PATH/get-max-prefix.sh     $DST_PATH Network-Conf.txt)
PREFIX_AUTH=$($CMD_PATH/get-max-prefix.sh             $DST_PATH Auth.txt)
PREFIX_STORAGE=$($CMD_PATH/get-max-prefix.sh          $DST_PATH Storage.txt)
PREFIX_OTHER=$($CMD_PATH/get-max-prefix.sh            $DST_PATH Other.txt)
##########################################################################################

MY_EXT_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Ext-net-nic-name)
$CMD_PATH/set-conf-data.sh ./interface.txt INTERFACE_NAME $MY_EXT_NET_NIC_NAME

echo $STR_WELCOME
mkdir -p $CONF_DEPLOY_DIR
MY_NIC_NAME=$($CMD_PATH/get-conf-data.sh ./interface.txt INTERFACE_NAME)

#Generate Servers-IPs.txt
rm -f $CONF_DEPLOY_DIR/Servers-IPs.txt
touch $CONF_DEPLOY_DIR/Servers-IPs.txt
for s in $(cat $DST_PATH/$PREFIX_SERVERS-Servers.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    echo $MY_IP >> $CONF_DEPLOY_DIR/Servers-IPs.txt
done

#Generate Front-Nodes-IPs.txt
rm -f $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt
touch $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt
for s in $(cat $DST_PATH/$PREFIX_FRONT_NODES-Front-Nodes.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    echo $MY_IP >> $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt
done

#Generate Controller-Nodes-IPs.txt
rm -f $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt
touch $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt
for s in $(cat $DST_PATH/$PREFIX_CONTROLLER_NODES-Controller-Nodes.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    echo $MY_IP >> $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt
done

#Generate Network-Nodes-IPs.txt
rm -f $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt
touch $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt
for s in $(cat $DST_PATH/$PREFIX_NETWORK_NODES-Network-Nodes.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    echo $MY_IP >> $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt
done

#Generate Computer-Nodes-IPs.txt
rm -f $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt
touch $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt
for s in $(cat $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    echo $MY_IP >> $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt
done

#Copy files to servers
mkdir -p $CMD_PATH/log
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Servers-IPs.txt 10
echo $STR_COPY_FILES_TO_SERVERS
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh
screen   -S niu -U -X screen   -U -t copy-files $CMD_PATH/copy-files-to-all-servers.sh $RUN_DATE
$CMD_PATH/check-screen-ended.sh

#Prepare all servers
echo $STR_PREPARE_ALL_SERVERS
$CMD_PATH/prepare-all-servers.sh $RUN_DATE

#Installation on Front Nodes
$CMD_PATH/front-nodes-install.sh $RUN_DATE

#Installation on Controller Nodes
$CMD_PATH/controller-nodes-install.sh $RUN_DATE

#Installation on Network Nodes
$CMD_PATH/network-nodes-install.sh $RUN_DATE

#Installation on Computer Nodes
$CMD_PATH/computer-nodes-install.sh $RUN_DATE

#Stop 5 services on last 2 controller nodes
$CMD_PATH/stop-5-services-on-last-2-controller-nodes.sh

#Run post installation scripts on first controller node
$CMD_PATH/run-post-install-script.sh $RUN_DATE

#

##########################################################################################
HISTROY_FILE=action-prefix-history.txt

if [ ! -e $CONF_DEPLOY_DIR/$HISTROY_FILE ]; then
    echo "Servers,Server-Info,Front-Nodes,Controller-Nodes,Network-Nodes,Computer-Nodes,Network-Conf,Auth,Storage,Other" > $CONF_DEPLOY_DIR/$HISTROY_FILE
fi

echo "$PREFIX_SERVERS,$PREFIX_SERVER_INFO,$PREFIX_FRONT_NODES,$PREFIX_CONTROLLER_NODES,$PREFIX_NETWORK_NODES,$PREFIX_COMPUTER_NODES,$PREFIX_NETWORK_CONF,$PREFIX_AUTH,$PREFIX_STORAGE,$PREFIX_OTHER" >> $CONF_DEPLOY_DIR/$HISTROY_FILE
##########################################################################################

echo $STR_DONE

echo $STR_VISIT_INFO
$CMD_PATH/show-visit-info.sh

echo $STR_THANKS_INFO
$CMD_PATH/show-thanks-info.sh

#

exit 0
