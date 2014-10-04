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

PREFIX_SERVERS=$($CMD_PATH/get-max-prefix.sh          $DST_PATH Servers.txt)
PREFIX_SERVER_INFO=$($CMD_PATH/get-max-prefix.sh      $DST_PATH Server-Info.txt)

mkdir -p $CONF_DEPLOY_DIR
MY_NIC_NAME=$($CMD_PATH/get-conf-data.sh ./interface.txt INTERFACE_NAME)

for s in $(cat $DST_PATH/$PREFIX_SERVERS-Servers.txt); do
    MY_IP=$($CMD_PATH/get-ip-by-server-nic-name.sh $DST_PATH $PREFIX_SERVER_INFO-Server-Info.txt $s $MY_NIC_NAME)
    rsync -va ./OpenStack-Install-HA              $MY_IP:/root/
    ssh   $MY_IP "rm -f /root/OpenStack-Install-HA/env.sh"
    rsync -va $DST_PATH/$PREFIX_SERVERS-$s-env.sh $MY_IP:/root/OpenStack-Install-HA/
    ssh   $MY_IP "mv -f /root/OpenStack-Install-HA/$PREFIX_SERVERS-$s-env.sh /root/OpenStack-Install-HA/env.sh"
done

for MY_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    rsync -va ./mysql_galera $MY_IP:/root/OpenStack-Install-HA/
done

MY_IP=$(head -n 1 $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt)
rsync -va ./images $MY_IP:/root/OpenStack-Install-HA/

#

exit 0
