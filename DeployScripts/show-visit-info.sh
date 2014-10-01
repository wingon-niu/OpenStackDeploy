#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
MY_LOCALE=$($CMD_PATH/get-conf-data.sh ./locale.txt LOCALE)
if [ $MY_LOCALE = 'CN' ]; then
    source ./locale_cn.txt
else
    source ./locale_en.txt
fi

PREFIX_NETWORK_CONF=$($CMD_PATH/get-max-prefix.sh     $DST_PATH Network-Conf.txt)
MY_EXT_NET_VIP=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Ext-net-vip)
MY_INT_NET_VIP=$($CMD_PATH/get-conf-data.sh $DST_PATH/$PREFIX_NETWORK_CONF-Network-Conf.txt Admin-net-vip)

echo "  http://$MY_EXT_NET_VIP/horizon"
echo "  http://$MY_INT_NET_VIP/horizon"

exit 0
