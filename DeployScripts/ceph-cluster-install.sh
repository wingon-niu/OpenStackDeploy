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

echo $STR_BEGIN_CEPH_CLUSTER_INSTALL_PART_1

#

echo $STR_BEGIN_CEPH_CLUSTER_INSTALL_PART_2

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

exit 0
