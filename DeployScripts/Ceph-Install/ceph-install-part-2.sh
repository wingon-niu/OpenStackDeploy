#!/bin/bash

HOST_NAME=$(hostname)
echo "Now running ceph-install-part-2.sh on $HOST_NAME"

for HOST_NAME in $(cat ./conf/ceph-client-hostname-info.txt | awk '{print $3}'); do
    ./check-ssh-connect.expect $HOST_NAME
done

for HOST_NAME in $(cat ./conf/ceph-server-hostname-info.txt | awk '{print $3}'); do
    ./check-ssh-connect.expect $HOST_NAME
done

#Begin ceph deploy
CURRENT_DIR=$(pwd)
mkdir -p /root/my-ceph-cluster
cd /root/my-ceph-cluster
pwd

#Create the cluster
CEPH_MON_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-mon-ip-hostname-info.txt "")
echo "Run command: ceph-deploy new $CEPH_MON_NODES"
################## ceph-deploy new $CEPH_MON_NODES

#Change the default number of replicas in the Ceph configuration file from 3 to 2
#here

cd $CURRENT_DIR

#

exit 0
