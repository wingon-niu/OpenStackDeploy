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

#Start ceph cluster installation
mkdir -p $CONF_DEPLOY_DIR

#Modify /etc/hosts for ceph nodes
echo "Modify /etc/hosts for ceph nodes"

for MY_IP in $(cat ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt); do
    echo $MY_IP
    rsync -vaI root@$MY_IP:/etc/hosts ./
    ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
    cat ./Ceph-Install/conf/ceph-server-nodes-hosts.txt >> ./hosts
    rsync -vaI ./hosts root@$MY_IP:/etc/
done

for MY_IP in $(cat ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt); do
    echo $MY_IP
    rsync -vaI root@$MY_IP:/etc/hosts ./
    ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
    cat ./Ceph-Install/conf/ceph-server-nodes-hosts.txt >> ./hosts
    ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-client-nodes-hosts.txt
    cat ./Ceph-Install/conf/ceph-client-nodes-hosts.txt >> ./hosts
    rsync -vaI ./hosts root@$MY_IP:/etc/
done

rm -f ./hosts

echo $STR_BEGIN_CEPH_CLUSTER_INSTALL_PART_1
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

MY_IP=$(head -n 1 ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt)
screen   -S niu -U -X screen   -U -t $MY_IP $CMD_PATH/run-on-ceph-node.expect $MY_IP ceph-install-part-1.sh $RUN_DATE-ceph-install-part-1-$MY_IP.log
$CMD_PATH/check-screen-ended.sh

echo $STR_GET_LOG_FILE_FROM_SERVERS
rsync -va $MY_IP:/root/Ceph-Install/log/$RUN_DATE-ceph-install-part-1-$MY_IP.log $CMD_PATH/log/

#Copy ssh public key of ceph admin node to ceph client and server nodes
echo "Copy ssh public key of ceph admin node to ceph client and server nodes"

CEPH_ADMIN_NODE_IP=$(head -n 1 ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt)
rsync -vaI root@$CEPH_ADMIN_NODE_IP:/root/.ssh/id_rsa.pub ./

for MY_IP in $(cat ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt); do
    rsync -vaI ./id_rsa.pub root@$MY_IP:/root/
    ssh root@$MY_IP "touch /root/.ssh/authorized_keys;cat /root/id_rsa.pub >> /root/.ssh/authorized_keys;rm -f /root/id_rsa.pub;"
done

rm -f ./id_rsa.pub

echo $STR_BEGIN_CEPH_CLUSTER_INSTALL_PART_2
screen -dmS niu -U -t sleeping $CMD_PATH/sleep-x-seconds.sh 10
$CMD_PATH/check-screen-started.sh

MY_IP=$(head -n 1 ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt)
screen   -S niu -U -X screen   -U -t $MY_IP $CMD_PATH/run-on-ceph-node.expect $MY_IP ceph-install-part-2.sh $RUN_DATE-ceph-install-part-2-$MY_IP.log
$CMD_PATH/check-screen-ended.sh

echo $STR_GET_LOG_FILE_FROM_SERVERS
rsync -va $MY_IP:/root/Ceph-Install/log/$RUN_DATE-ceph-install-part-2-$MY_IP.log $CMD_PATH/log/

#

##########################################################################################
PREFIX_CEPH_ADMIN_NODE=$($CMD_PATH/get-max-prefix.sh $DST_PATH ceph-admin-node.txt)
PREFIX_CEPH_MON_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-mon-node.txt)
PREFIX_CEPH_OSD_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-osd-node.txt)
PREFIX_CEPH_MDS_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-mds-node.txt)

HISTROY_FILE=ceph-install-prefix-history.txt

if [ ! -e $CONF_DEPLOY_DIR/$HISTROY_FILE ]; then
    echo "ceph-admin,ceph-mon,ceph-osd,ceph-mds" > $CONF_DEPLOY_DIR/$HISTROY_FILE
fi

echo "$PREFIX_CEPH_ADMIN_NODE,$PREFIX_CEPH_MON_NODE,$PREFIX_CEPH_OSD_NODE,$PREFIX_CEPH_MDS_NODE" >> $CONF_DEPLOY_DIR/$HISTROY_FILE
##########################################################################################

#

exit 0
