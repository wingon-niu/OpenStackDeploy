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

echo $STR_STOP_SOME_SERVICES
for IP in $(tail -n 2 $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo $IP
    ssh root@$IP "cd /root/OpenStack-Install-HA;./stop-service-glance.sh;./stop-service-cinder.sh;./stop-service-horizon.sh;"
    ssh root@$IP "service nova-consoleauth stop;service nova-novncproxy stop;"
done

exit 0
