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

#Install Ceph on ceph server nodes
CEPH_SERVER_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-server-hostname-info.txt "")
echo "Run command: ceph-deploy install $CEPH_SERVER_NODES"
################## ceph-deploy install $CEPH_SERVER_NODES

#Add the initial monitor(s) and gather the keys
echo "Run command: ceph-deploy mon create-initial"
################## ceph-deploy mon create-initial

#Create directory on ceph osd nodes
OSD_DATA_DIR=/data/osd
for HOST_NAME in $(cat $CURRENT_DIR/conf/ceph-osd-ip-hostname-info.txt | awk '{print $3}'); do
    echo "Run command on $HOST_NAME: mkdir -p $OSD_DATA_DIR"
    ssh root@$HOST_NAME             "mkdir -p $OSD_DATA_DIR"
done

#Add OSDs
CEPH_OSD_NODES_INFO=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-osd-ip-hostname-info.txt ":$OSD_DATA_DIR")
echo "Run command: ceph-deploy osd prepare  $CEPH_OSD_NODES_INFO"
################## ceph-deploy osd prepare  $CEPH_OSD_NODES_INFO
echo "Run command: ceph-deploy osd activate $CEPH_OSD_NODES_INFO"
################## ceph-deploy osd activate $CEPH_OSD_NODES_INFO

#Send configuration file and admin key to all ceph server nodes
echo "Run command: ceph-deploy admin $CEPH_SERVER_NODES"
################## ceph-deploy admin $CEPH_SERVER_NODES

#Set permissions for the ceph.client.admin.keyring on all ceph server nodes
for HOST_NAME in $(cat $CURRENT_DIR/conf/ceph-server-hostname-info.txt | awk '{print $3}'); do
    echo "Run command on $HOST_NAME: chmod +r /etc/ceph/ceph.client.admin.keyring"
    ssh root@$HOST_NAME             "chmod +r /etc/ceph/ceph.client.admin.keyring"
done

#Add a metadata server
CEPH_MDS_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-mds-ip-hostname-info.txt "")
echo "Run command: ceph-deploy mds create $CEPH_MDS_NODES"
################## ceph-deploy mds create $CEPH_MDS_NODES

#Install Ceph on ceph client nodes
CEPH_CLIENT_NODES=$($CURRENT_DIR/gen-server-info-list.sh $CURRENT_DIR/conf/ceph-client-hostname-info.txt "")
echo "Run command: ceph-deploy install $CEPH_CLIENT_NODES"
################## ceph-deploy install $CEPH_CLIENT_NODES

#Send configuration file and admin key to all ceph client nodes
echo "Run command: ceph-deploy admin $CEPH_CLIENT_NODES"
################## ceph-deploy admin $CEPH_CLIENT_NODES

#Set permissions for the ceph.client.admin.keyring on all ceph client nodes
for HOST_NAME in $(cat $CURRENT_DIR/conf/ceph-client-hostname-info.txt | awk '{print $3}'); do
    echo "Run command on $HOST_NAME: chmod +r /etc/ceph/ceph.client.admin.keyring"
    ssh root@$HOST_NAME             "chmod +r /etc/ceph/ceph.client.admin.keyring"
done

#

cd $CURRENT_DIR

#

exit 0
