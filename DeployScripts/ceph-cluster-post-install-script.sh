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

#Run ceph cluster post install scripts
echo "Run ceph cluster post install scripts"

MY_IP=$(head -n 1 ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt)
echo $MY_IP
ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./ceph-prepare-for-openstack.sh;"

#Here

#

exit 0
