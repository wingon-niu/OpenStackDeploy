#!/bin/bash

source ./env.sh

echo "Begin time of pacemaker-corosync-install:"
date

#Modify /etc/hosts
CONF_FILE=/etc/hosts
./backup-file.sh $CONF_FILE

echo ""                                                >> $CONF_FILE
echo "$COROSYNC_NODE_01_IP $COROSYNC_NODE_01_HOSTNAME" >> $CONF_FILE
echo "$COROSYNC_NODE_02_IP $COROSYNC_NODE_02_HOSTNAME" >> $CONF_FILE
echo ""                                                >> $CONF_FILE

#Install pacemaker and corosync
apt-get install -y pacemaker corosync

#Modify /etc/corosync/corosync.conf
CONF_FILE=/etc/corosync/corosync.conf
./backup-file.sh   $CONF_FILE
cp ./corosync.conf $CONF_FILE
sed -i "s/xxx.xxx.xxx.xxx/$COROSYNC_BINDNETADDR/g" $CONF_FILE

#Other settings
mkdir -p /var/log/cluster
update-rc.d pacemaker start 50 1 2 3 4 5 . stop 01 0 6 .
sed -i '/^START=/c START=yes' /etc/default/corosync

#Start corosync and check it
service corosync start
sleep 1
corosync-cfgtool -s
corosync-quorumtool -l

#Start pacemaker and check it
service pacemaker start
sleep 1
crm status

#Other settings
crm configure property no-quorum-policy=ignore
crm configure property stonith-enabled=false
crm configure rsc_defaults resource-stickiness=100
crm configure property pe-warn-series-max="1000"
crm configure property pe-input-series-max="1000"
crm configure property pe-error-series-max="1000"
crm configure property cluster-recheck-interval="5min"

#Show configuration info
sleep 1
crm configure show
crm_verify -L

#Show cluster status
crm status

#

echo "End time of pacemaker-corosync-install:"
date

