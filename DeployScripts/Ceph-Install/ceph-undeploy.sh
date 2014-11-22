#!/bin/bash

MY_HOST_NAME=$(hostname)
echo "Now running ceph undeploy on $MY_HOST_NAME"

#

CURRENT_DIR=$(pwd)
cd /root/my-ceph-cluster
pwd

if [ $(cat $CURRENT_DIR/conf/ceph-client-hostname-info.txt | wc -l) -gt 0 ]; then
    #Uninstall Ceph on ceph client nodes
    CEPH_CLIENT_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-client-hostname-info.txt "")
    echo "Run command: ceph-deploy purge $CEPH_CLIENT_NODES"
                       ceph-deploy purge $CEPH_CLIENT_NODES
fi

#Uninstall Ceph on ceph server nodes, and purge data
CEPH_SERVER_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-server-hostname-info.txt "")
echo "Run command: ceph-deploy purge     $CEPH_SERVER_NODES"
                   ceph-deploy purge     $CEPH_SERVER_NODES
echo "Run command: ceph-deploy purgedata $CEPH_SERVER_NODES"
                   ceph-deploy purgedata $CEPH_SERVER_NODES

#Delete keys
echo "Run command: ceph-deploy forgetkeys"
                   ceph-deploy forgetkeys

#

cd $CURRENT_DIR
rm -rf /root/my-ceph-cluster

#

exit 0
