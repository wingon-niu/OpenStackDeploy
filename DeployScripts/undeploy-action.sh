#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
RUN_DATE=$1
source ./locale_en.txt

#

if [ ! -d $CONF_DEPLOY_DIR                          -o \
     ! -f $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt      -o \
     ! -f $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt -o \
     ! -f $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt    -o \
     ! -f $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt      \
   ]; then

    echo "Error: Info files needed for undeploy not exist! Can not undeploy."
    exit 1

fi

echo "Begin undeploy OpenStack Cluster..."

#If used neutron on network nodes, need to unconfigure ovs networking on network nodes first.
HISTROY_FILE=action-prefix-history.txt
MY_PREFIX=$(tail -n 1 $CONF_DEPLOY_DIR/$HISTROY_FILE | awk -F',' '{print $7}')
MY_NETWORK_API_CLASS=$($CMD_PATH/get-conf-data.sh $DST_PATH/$MY_PREFIX-Network-Conf.txt Network-api-class)
if [ "$MY_NETWORK_API_CLASS" = "neutron" ]; then
    echo "Network nodes used neutron, need to unconfigure ovs networking on network nodes first..."
    echo $STR_PING_ALL_SERVERS
    $CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt 10
    for MY_IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
        echo "Connecting to network node: $MY_IP"
        ssh root@$MY_IP "nohup /root/OpenStack-Install-HA/network-node-ovs-uninstall.sh > /root/OpenStack-Install-HA/log/network-node-ovs-uninstall.log 2>&1 &"
        echo "Done."
    done
fi

echo "Undeploying Computer Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt); do
    echo "Connecting to compute node: $MY_IP"
#   ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./compute-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-compute-node-uninstall.log;"
    $CMD_PATH/run-on-node.expect $MY_IP compute-node-uninstall.sh $RUN_DATE-compute-node-uninstall.log
done

echo "Undeploying Network Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Network-Nodes-IPs.txt); do
    echo "Connecting to network node: $MY_IP"
#   ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./network-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-network-node-uninstall.log;"
    $CMD_PATH/run-on-node.expect $MY_IP network-node-uninstall.sh $RUN_DATE-network-node-uninstall.log
done

echo "Undeploying Controller Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo "Connecting to controller node: $MY_IP"
#   ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./controller-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-controller-node-uninstall.log;"
    $CMD_PATH/run-on-node.expect $MY_IP controller-node-uninstall.sh $RUN_DATE-controller-node-uninstall.log
done

echo "Undeploying Front Nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Front-Nodes-IPs.txt); do
    echo "Connecting to front node: $MY_IP"
#   ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./front-node-uninstall.sh 2>&1 | tee ./log/$RUN_DATE-front-node-uninstall.log;"
    $CMD_PATH/run-on-node.expect $MY_IP front-node-uninstall.sh $RUN_DATE-front-node-uninstall.log
done

#If used ceph, undeploy ceph cluster.
PREFIX_STORAGE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH  Storage.txt)
MY_GLANCE_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt GLANCE_STORAGE)
MY_CINDER_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt CINDER_STORAGE)
MY_NOVA_STORAGE=$($CMD_PATH/get-conf-data.sh   $DST_PATH/$PREFIX_STORAGE-Storage.txt NOVA_STORAGE)

if [ "$MY_GLANCE_STORAGE" = "ceph" -o "$MY_CINDER_STORAGE" = "ceph" -o "$MY_NOVA_STORAGE" = "ceph" ]; then
    echo "Undeploying Ceph Cluster..."
    MY_IP=$(head -n 1 ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt)
    echo "Connecting to ceph admin node: $MY_IP"
#   ssh root@$MY_IP "cd /root/Ceph-Install;./ceph-undeploy.sh 2>&1 | tee ./log/$RUN_DATE-ceph-undeploy.log;"
    $CMD_PATH/run-on-ceph-node.expect $MY_IP ceph-undeploy.sh $RUN_DATE-ceph-undeploy.log

    echo "Delete host info in /etc/hosts on all ceph nodes..."
    for MY_IP in $(cat ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt); do
        echo $MY_IP
        rsync -vaI root@$MY_IP:/etc/hosts ./
        ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
        rsync -vaI ./hosts root@$MY_IP:/etc/
    done
    for MY_IP in $(cat ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt); do
        echo $MY_IP
        rsync -vaI root@$MY_IP:/etc/hosts ./
        ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
        ./Ceph-Install/delete-file2-in-file1.sh ./hosts ./Ceph-Install/conf/ceph-client-nodes-hosts.txt
        rsync -vaI ./hosts root@$MY_IP:/etc/
    done
    rm -f ./hosts
fi

echo "Delete message queue host info in /etc/hosts on controller nodes..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo "Connecting to controller node: $MY_IP"
    ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./del-mq-hosts-info.sh 2>&1 | tee ./log/$RUN_DATE-del-mq-hosts-info.log;"
done

echo "Delete install files on all servers..."
echo $STR_PING_ALL_SERVERS
$CMD_PATH/check-servers-running.sh $CONF_DEPLOY_DIR/Servers-IPs.txt 10
for MY_IP in $(cat $CONF_DEPLOY_DIR/Servers-IPs.txt); do
    echo "Connecting to $MY_IP"
    ssh root@$MY_IP "cd /root;rm -rf ./OpenStack-Install-HA;rm -rf ./Ceph-Install;cd /etc/apt/sources.list.d;rm -f ./openstack.list;rm -f ./ceph.list;"
done

echo "Undeploy completed."

#

exit 0
