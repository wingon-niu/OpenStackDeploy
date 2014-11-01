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

#Generate needed files for OpenStack
MY_IP=$(head -n 1 ./Ceph-Install/conf/ceph-client-server-nodes-ext-ip.txt)
echo "Generate needed files for OpenStack on $MY_IP"
ssh root@$MY_IP "cd /root/OpenStack-Install-HA;./ceph-prepare-for-openstack.sh;"

#Copy needed files for OpenStack to local server
echo "Copy needed files for OpenStack to local server"
rsync -vaI root@$MY_IP:/root/ceph.client.*.keyring $CMD_PATH/
rsync -vaI root@$MY_IP:/root/client.cinder.key     $CMD_PATH/
rsync -vaI root@$MY_IP:/root/uuid.txt              $CMD_PATH/
rsync -vaI root@$MY_IP:/root/secret.xml            $CMD_PATH/
ssh root@$MY_IP "cd /root;rm -f ceph.client.*.keyring;rm -f client.cinder.key;rm -f uuid.txt;rm -f secret.xml;"

#Copy needed files to controller nodes
for NODE_IP in $(cat $CONF_DEPLOY_DIR/Controller-Nodes-IPs.txt); do
    echo "Copy needed files for OpenStack to controller node: $NODE_IP"
    rsync -vaI $CMD_PATH/ceph.client.*.keyring root@$NODE_IP:/etc/ceph/
    rsync -vaI $CMD_PATH/uuid.txt              root@$NODE_IP:/root/OpenStack-Install-HA/
done

#Copy needed files to computer nodes
for NODE_IP in $(cat $CONF_DEPLOY_DIR/Computer-Nodes-IPs.txt); do
    echo "Copy needed files for OpenStack to computer node: $NODE_IP"
    rsync -vaI $CMD_PATH/client.cinder.key root@$NODE_IP:/root/OpenStack-Install-HA/
    rsync -vaI $CMD_PATH/uuid.txt          root@$NODE_IP:/root/OpenStack-Install-HA/
    rsync -vaI $CMD_PATH/secret.xml        root@$NODE_IP:/root/OpenStack-Install-HA/
done

#Delete these files from local server
echo "Delete these files from local server"
echo "Run command: rm -f $CMD_PATH/ceph.client.*.keyring;rm -f $CMD_PATH/client.cinder.key;rm -f $CMD_PATH/uuid.txt;rm -f $CMD_PATH/secret.xml;"
                   rm -f $CMD_PATH/ceph.client.*.keyring;rm -f $CMD_PATH/client.cinder.key;rm -f $CMD_PATH/uuid.txt;rm -f $CMD_PATH/secret.xml;

#

exit 0
