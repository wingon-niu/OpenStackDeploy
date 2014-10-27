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
/root/OpenStack-Install-HA/set-config.py ./ceph.conf global osd_pool_default_size 2

#Add the ceph public and cluster network setting
CEPH_PUBLIC_NETWORK_IP=$(head  -n 1 $CURRENT_DIR/conf/ceph-mon-ip-hostname-info.txt | awk '{print $1}')
CEPH_CLUSTER_NETWORK_IP=$(head -n 1 $CURRENT_DIR/conf/ceph-mon-ip-hostname-info.txt | awk '{print $2}')
CEPH_PUB_NET=${CEPH_PUBLIC_NETWORK_IP%.*}.0/24
CEPH_CLT_NET=${CEPH_CLUSTER_NETWORK_IP%.*}.0/24
echo "Ceph public  network : $CEPH_PUBLIC_NETWORK_IP   $CEPH_PUB_NET"
echo "Ceph cluster network : $CEPH_CLUSTER_NETWORK_IP  $CEPH_CLT_NET"
/root/OpenStack-Install-HA/set-config.py     ./ceph.conf global public_network  $CEPH_PUB_NET
if [ "$CEPH_PUB_NET" != "$CEPH_CLT_NET" ]; then
    /root/OpenStack-Install-HA/set-config.py ./ceph.conf global cluster_network $CEPH_CLT_NET
fi

#Install Ceph
#here

#

cd $CURRENT_DIR

#

exit 0
