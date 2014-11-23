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

#If use ceph
MY_GLANCE_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt GLANCE_STORAGE)
MY_CINDER_STORAGE=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_STORAGE-Storage.txt CINDER_STORAGE)
MY_NOVA_STORAGE=$($CMD_PATH/get-conf-data.sh   $DST_PATH/$PREFIX_STORAGE-Storage.txt NOVA_STORAGE)

if [ "$MY_GLANCE_STORAGE" = "ceph" -o "$MY_CINDER_STORAGE" = "ceph" -o "$MY_NOVA_STORAGE" = "ceph" ]; then
    ###### Temp action begin ####################################

    #Generate 101-ceph-admin-node.txt
    rm -f $DST_PATH/101-ceph-admin-node.txt
    touch $DST_PATH/101-ceph-admin-node.txt
    tail -n 1 $DST_PATH/$PREFIX_FRONT_NODES-Front-Nodes.txt >> $DST_PATH/101-ceph-admin-node.txt

    #Generate 101-ceph-mon-node.txt
    rm -f $DST_PATH/101-ceph-mon-node.txt
    touch $DST_PATH/101-ceph-mon-node.txt
    cat $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt >> $DST_PATH/101-ceph-mon-node.txt

    #Generate 101-ceph-osd-node.txt
    rm -f $DST_PATH/101-ceph-osd-node.txt
    touch $DST_PATH/101-ceph-osd-node.txt
    cat $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt >> $DST_PATH/101-ceph-osd-node.txt

    #Generate 101-ceph-mds-node.txt
    rm -f $DST_PATH/101-ceph-mds-node.txt
    touch $DST_PATH/101-ceph-mds-node.txt
    head -n 1 $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt >> $DST_PATH/101-ceph-mds-node.txt

    ###### Temp action end   ####################################

    PREFIX_CEPH_ADMIN_NODE=$($CMD_PATH/get-max-prefix.sh $DST_PATH ceph-admin-node.txt)
    PREFIX_CEPH_MON_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-mon-node.txt)
    PREFIX_CEPH_OSD_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-osd-node.txt)
    PREFIX_CEPH_MDS_NODE=$($CMD_PATH/get-max-prefix.sh   $DST_PATH ceph-mds-node.txt)

    CEPH_EXT_NET_NIC_NAME=$MY_NIC_NAME
    CEPH_ADMIN_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh   $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Admin-net-nic-name)
    CEPH_PUBLIC_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh  $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Ceph-public-net-nic-name)
    CEPH_CLUSTER_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Ceph-cluster-net-nic-name)
    if [ "$CEPH_PUBLIC_NET_NIC_NAME" = '' ]; then
        CEPH_PUBLIC_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh  $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Admin-net-nic-name)
    fi
    if [ "$CEPH_CLUSTER_NET_NIC_NAME" = '' ]; then
        CEPH_CLUSTER_NET_NIC_NAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Admin-net-nic-name)
    fi

    #Generate distinct ceph client nodes file
    cat $DST_PATH/$PREFIX_CONTROLLER_NODES-Controller-Nodes.txt > ./Ceph-Install/conf/ceph-client-nodes.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-client-nodes.txt $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt
    cat $DST_PATH/$PREFIX_COMPUTER_NODES-Computer-Nodes.txt    >> ./Ceph-Install/conf/ceph-client-nodes.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-client-nodes.txt $DST_PATH/$PREFIX_CEPH_ADMIN_NODE-ceph-admin-node.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-client-nodes.txt $DST_PATH/$PREFIX_CEPH_MON_NODE-ceph-mon-node.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-client-nodes.txt $DST_PATH/$PREFIX_CEPH_OSD_NODE-ceph-osd-node.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-client-nodes.txt $DST_PATH/$PREFIX_CEPH_MDS_NODE-ceph-mds-node.txt

    #Generate distinct ceph server nodes file
    cat $DST_PATH/$PREFIX_CEPH_MON_NODE-ceph-mon-node.txt  > ./Ceph-Install/conf/ceph-server-nodes.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-server-nodes.txt $DST_PATH/$PREFIX_CEPH_OSD_NODE-ceph-osd-node.txt
    cat $DST_PATH/$PREFIX_CEPH_OSD_NODE-ceph-osd-node.txt >> ./Ceph-Install/conf/ceph-server-nodes.txt
    ./Ceph-Install/delete-file2-in-file1.sh ./Ceph-Install/conf/ceph-server-nodes.txt $DST_PATH/$PREFIX_CEPH_MDS_NODE-ceph-mds-node.txt
    cat $DST_PATH/$PREFIX_CEPH_MDS_NODE-ceph-mds-node.txt >> ./Ceph-Install/conf/ceph-server-nodes.txt

    #Generate ceph admin node ext ip file
    server_name=$(head -n 1 $DST_PATH/$PREFIX_CEPH_ADMIN_NODE-ceph-admin-node.txt)
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_EXT_NET_NIC_NAME)
    echo $MY_IP > ./Ceph-Install/conf/ceph-admin-node-ext-ip.txt

    #Generate ceph client and server nodes ext ip file
    rm -f ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt
    touch ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt
    if [ $(cat ./Ceph-Install/conf/ceph-client-nodes.txt | wc -l) -gt 0 ]; then
        for server_name in $(cat ./Ceph-Install/conf/ceph-client-nodes.txt); do
            MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_EXT_NET_NIC_NAME)
            echo $MY_IP >> ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt
        done
    fi
    for server_name in $(cat ./Ceph-Install/conf/ceph-server-nodes.txt); do
        MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_EXT_NET_NIC_NAME)
        echo $MY_IP >> ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt
    done

    #Generate ceph client nodes hosts file
    echo "#Used for ceph"  > ./Ceph-Install/conf/ceph-client-nodes-hosts.txt
    if [ $(cat ./Ceph-Install/conf/ceph-client-nodes.txt | wc -l) -gt 0 ]; then
        for server_name in $(cat ./Ceph-Install/conf/ceph-client-nodes.txt); do
            MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_ADMIN_NET_NIC_NAME)
            MY_HOSTNAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_SERVER_INFO-Server-Info.txt ${server_name}-hostname)
            echo "$MY_IP  $MY_HOSTNAME" >> ./Ceph-Install/conf/ceph-client-nodes-hosts.txt
        done
    fi

    #Generate ceph server nodes hosts file
    echo "#Used for ceph"  > ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
    for server_name in $(cat ./Ceph-Install/conf/ceph-server-nodes.txt); do
        MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_PUBLIC_NET_NIC_NAME)
        MY_HOSTNAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_SERVER_INFO-Server-Info.txt ${server_name}-hostname)
        echo "$MY_IP  $MY_HOSTNAME" >> ./Ceph-Install/conf/ceph-server-nodes-hosts.txt
    done

    #Generate ceph mon nodes ip and hostname info file
    rm -f ./Ceph-Install/conf/ceph-mon-ip-hostname-info.txt
    touch ./Ceph-Install/conf/ceph-mon-ip-hostname-info.txt
    for server_name in $(cat $DST_PATH/$PREFIX_CEPH_MON_NODE-ceph-mon-node.txt); do
        MY_PUBLIC_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh  $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_PUBLIC_NET_NIC_NAME)
        MY_CLUSTER_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_CLUSTER_NET_NIC_NAME)
        MY_HOSTNAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_SERVER_INFO-Server-Info.txt ${server_name}-hostname)
        echo "$MY_PUBLIC_IP $MY_CLUSTER_IP $MY_HOSTNAME" >> ./Ceph-Install/conf/ceph-mon-ip-hostname-info.txt
    done

    #Generate ceph osd nodes ip and hostname info file
    rm -f ./Ceph-Install/conf/ceph-osd-ip-hostname-info.txt
    touch ./Ceph-Install/conf/ceph-osd-ip-hostname-info.txt
    for server_name in $(cat $DST_PATH/$PREFIX_CEPH_OSD_NODE-ceph-osd-node.txt); do
        MY_PUBLIC_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh  $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_PUBLIC_NET_NIC_NAME)
        MY_CLUSTER_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_CLUSTER_NET_NIC_NAME)
        MY_HOSTNAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_SERVER_INFO-Server-Info.txt ${server_name}-hostname)
        echo "$MY_PUBLIC_IP $MY_CLUSTER_IP $MY_HOSTNAME" >> ./Ceph-Install/conf/ceph-osd-ip-hostname-info.txt
    done

    #Generate ceph mds nodes ip and hostname info file
    rm -f ./Ceph-Install/conf/ceph-mds-ip-hostname-info.txt
    touch ./Ceph-Install/conf/ceph-mds-ip-hostname-info.txt
    for server_name in $(cat $DST_PATH/$PREFIX_CEPH_MDS_NODE-ceph-mds-node.txt); do
        MY_PUBLIC_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh  $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_PUBLIC_NET_NIC_NAME)
        MY_CLUSTER_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $server_name $CEPH_CLUSTER_NET_NIC_NAME)
        MY_HOSTNAME=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_SERVER_INFO-Server-Info.txt ${server_name}-hostname)
        echo "$MY_PUBLIC_IP $MY_CLUSTER_IP $MY_HOSTNAME" >> ./Ceph-Install/conf/ceph-mds-ip-hostname-info.txt
    done

    #Generate ceph client nodes hostname info file
    rm -f ./Ceph-Install/conf/ceph-client-hostname-info.txt
    touch ./Ceph-Install/conf/ceph-client-hostname-info.txt
    if [ $(cat ./Ceph-Install/conf/ceph-client-nodes-hosts.txt | grep -v '#' | wc -l) -gt 0 ]; then
        for host_name in $(cat ./Ceph-Install/conf/ceph-client-nodes-hosts.txt | grep -v '#' | awk '{print $2}'); do
            echo "aaa bbb $host_name" >> ./Ceph-Install/conf/ceph-client-hostname-info.txt
        done
    fi

    #Generate ceph server nodes hostname info file
    rm -f ./Ceph-Install/conf/ceph-server-hostname-info.txt
    touch ./Ceph-Install/conf/ceph-server-hostname-info.txt
    for host_name in $(cat ./Ceph-Install/conf/ceph-server-nodes-hosts.txt | grep -v '#' | awk '{print $2}'); do
        echo "aaa bbb $host_name" >> ./Ceph-Install/conf/ceph-server-hostname-info.txt
    done

    #Remember to save prefix info of ceph when ceph install completed
fi
#End if use ceph

#Use local openstack and ceph apt sources if exists
if [ -s ./sources.list.openstack ]; then
    REPO_1="http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main"
    REPO_2=${REPO_1//\//\\\/}
    REPO_3=$(head -n 1 ./sources.list.openstack)
    REPO_4=${REPO_3//\//\\\/}
    sed -i "s/$REPO_2/$REPO_4/g" ./OpenStack-Install-HA/node-3-preparing-openstack.sh
fi
if [ -s ./sources.list.ceph ]; then
    REPO_1="http://ceph.com/debian-firefly/ trusty main"
    REPO_2=${REPO_1//\//\\\/}
    REPO_3=$(head -n 1 ./sources.list.ceph)
    REPO_4=${REPO_3//\//\\\/}
    sed -i "s/$REPO_2/$REPO_4/g" ./Ceph-Install/ceph-install-part-1.sh
fi

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

#Install ceph if needed
if [ "$MY_GLANCE_STORAGE" = "ceph" -o "$MY_CINDER_STORAGE" = "ceph" -o "$MY_NOVA_STORAGE" = "ceph" ]; then
    $CMD_PATH/ceph-cluster-install.sh             $RUN_DATE
    $CMD_PATH/ceph-cluster-post-install-script.sh $RUN_DATE
fi

#Installation on Front Nodes
$CMD_PATH/front-nodes-install.sh $RUN_DATE

#Installation on Controller Nodes
$CMD_PATH/controller-nodes-install.sh $RUN_DATE

#Installation on Network Nodes
$CMD_PATH/network-nodes-install.sh $RUN_DATE

#Installation on Computer Nodes
$CMD_PATH/computer-nodes-install.sh $RUN_DATE

#Stop 2 services on last 2 controller nodes when not use ceph
if [ "$MY_GLANCE_STORAGE" != "ceph" -o "$MY_CINDER_STORAGE" != "ceph" ]; then
    $CMD_PATH/stop-5-services-on-last-2-controller-nodes.sh
fi

#Run post install scripts
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
