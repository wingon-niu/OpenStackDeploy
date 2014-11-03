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

#If use ceph
PREFIX_STORAGE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH Storage.txt)
MY_GLANCE_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt GLANCE_STORAGE)
MY_CINDER_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt CINDER_STORAGE)
MY_NOVA_STORAGE=$($CMD_PATH/get-conf-data.sh   $DST_PATH/$PREFIX_STORAGE-Storage.txt NOVA_STORAGE)

if [ "$MY_GLANCE_STORAGE" = "ceph" -o "$MY_CINDER_STORAGE" = "ceph" -o "$MY_NOVA_STORAGE" = "ceph" ]; then
    echo "Used ceph block devices, the format of image file needed be raw, now convert it ..."
    MY_CONTROLLER_NODE_IP=$(head -n 1 $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt)
    MY_COMPUTER_NODE_IP=$(head   -n 1 $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt)

    echo "Copy image file to computer node $MY_COMPUTER_NODE_IP, then convert format from qcow2 to raw"
    rsync -vaI ./images/cirros-0.3.2-x86_64-disk.img root@$MY_COMPUTER_NODE_IP:/root/OpenStack-Install-HA/images/
    ssh root@$MY_COMPUTER_NODE_IP "cd /root/OpenStack-Install-HA/images;qemu-img convert -f qcow2 -O raw cirros-0.3.2-x86_64-disk.img cirros-0.3.2-x86_64-disk.raw;"

    echo "Copy image file to local server then copy it to controller node $MY_CONTROLLER_NODE_IP"
    rsync -vaSI root@$MY_COMPUTER_NODE_IP:/root/OpenStack-Install-HA/images/cirros-0.3.2-x86_64-disk.raw ./
    rsync -vaSI ./cirros-0.3.2-x86_64-disk.raw root@$MY_CONTROLLER_NODE_IP:/root/OpenStack-Install-HA/images/
    rm -f ./cirros-0.3.2-x86_64-disk.raw
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
