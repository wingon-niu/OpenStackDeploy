#!/bin/bash

source ./env.sh

#Update /etc/glance/glance-api-paste.ini
conf_file_01=/etc/glance/glance-api-paste.ini
./backup-file.sh $conf_file_01

./set-config.py $conf_file_01 filter:authtoken auth_host         $KEYSTONE_HOST_IP
./set-config.py $conf_file_01 filter:authtoken auth_port         35357
./set-config.py $conf_file_01 filter:authtoken auth_protocol     http
./set-config.py $conf_file_01 filter:authtoken admin_tenant_name service
./set-config.py $conf_file_01 filter:authtoken admin_user        glance
./set-config.py $conf_file_01 filter:authtoken admin_password    $KEYSTONE_SERVICE_PASSWORD

#sed -i '/filter:authtoken/,$d' $conf_file_01
#echo "[filter:authtoken]"                                                                >> $conf_file_01
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_01
#echo "delay_auth_decision = true"                                                        >> $conf_file_01
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_01
#echo "auth_port = 35357"                                                                 >> $conf_file_01
#echo "auth_protocol = http"                                                              >> $conf_file_01
#echo "admin_tenant_name = service"                                                       >> $conf_file_01
#echo "admin_user = glance"                                                               >> $conf_file_01
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_01

#Update the /etc/glance/glance-registry-paste.ini
conf_file_02=/etc/glance/glance-registry-paste.ini
./backup-file.sh $conf_file_02

./set-config.py $conf_file_02 filter:authtoken auth_host         $KEYSTONE_HOST_IP
./set-config.py $conf_file_02 filter:authtoken auth_port         35357
./set-config.py $conf_file_02 filter:authtoken auth_protocol     http
./set-config.py $conf_file_02 filter:authtoken admin_tenant_name service
./set-config.py $conf_file_02 filter:authtoken admin_user        glance
./set-config.py $conf_file_02 filter:authtoken admin_password    $KEYSTONE_SERVICE_PASSWORD

#sed -i '/filter:authtoken/,$d' $conf_file_02
#echo "[filter:authtoken]"                                                                >> $conf_file_02
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_02
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_02
#echo "auth_port = 35357"                                                                 >> $conf_file_02
#echo "auth_protocol = http"                                                              >> $conf_file_02
#echo "admin_tenant_name = service"                                                       >> $conf_file_02
#echo "admin_user = glance"                                                               >> $conf_file_02
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_02

#Update /etc/glance/glance-api.conf
conf_file_03=/etc/glance/glance-api.conf
./backup-file.sh $conf_file_03

./set-config.py $conf_file_03 DEFAULT      sql_connection           mysql://$GLANCE_USER:$GLANCE_PASS@$DATABASE_IP/glance
./set-config.py $conf_file_03 DEFAULT      verbose                  true
./set-config.py $conf_file_03 DEFAULT      debug                    true
./set-config.py $conf_file_03 DEFAULT      rpc_backend              rabbit
./set-config.py $conf_file_03 DEFAULT      rabbit_hosts             $RABBIT_HOSTS
./set-config.py $conf_file_03 DEFAULT      rabbit_retry_interval    1
./set-config.py $conf_file_03 DEFAULT      rabbit_retry_backoff     2
./set-config.py $conf_file_03 DEFAULT      rabbit_max_retries       0
./set-config.py $conf_file_03 DEFAULT      rabbit_durable_queues    false
./set-config.py $conf_file_03 DEFAULT      rabbit_ha_queues         true
./set-config.py $conf_file_03 paste_deploy flavor                   keystone
#./set-config.py $conf_file_03 DEFAULT     db_enforce_mysql_charset false

if [ "$GLANCE_STORAGE" = "ceph" ]; then
    echo "GLANCE_STORAGE = ceph"
    ./set-config.py $conf_file_03 DEFAULT       default_store          rbd
    ./set-config.py $conf_file_03 DEFAULT       rbd_store_user         glance
    ./set-config.py $conf_file_03 DEFAULT       rbd_store_pool         images
    ./set-config.py $conf_file_03 DEFAULT       show_image_direct_url  True
    ./set-config.py $conf_file_03 paste_deploy  flavor                 keystone
    chown glance:glance /etc/ceph/ceph.client.glance.keyring
else
    echo "GLANCE_STORAGE = local_disk"
    ./set-config.py $conf_file_03 DEFAULT       default_store          file
    ./set-config.py $conf_file_03 DEFAULT       show_image_direct_url  False
fi

#sed -i '/^workers =/c workers = 4'                                                                    $conf_file_03
#sed -i '/^notifier_strategy =/c notifier_strategy = rabbit'                                           $conf_file_03
#sed -i "/^rabbit_host =/c rabbit_host = $MESSAGE_QUEUE_IP"                                            $conf_file_03
#sed -i "/sql_connection = /c sql_connection = mysql://$GLANCE_USER:$GLANCE_PASS@$DATABASE_IP/glance"  $conf_file_03
#sed -i '/flavor=/c flavor=keystone'                                                                   $conf_file_03

#Update the /etc/glance/glance-registry.conf
conf_file_04=/etc/glance/glance-registry.conf
./backup-file.sh $conf_file_04

./set-config.py $conf_file_04 DEFAULT      sql_connection mysql://$GLANCE_USER:$GLANCE_PASS@$DATABASE_IP/glance
./set-config.py $conf_file_04 DEFAULT      verbose        true
./set-config.py $conf_file_04 DEFAULT      debug          true
./set-config.py $conf_file_04 paste_deploy flavor         keystone

#sed -i "/sql_connection = /c sql_connection = mysql://$GLANCE_USER:$GLANCE_PASS@$DATABASE_IP/glance"  $conf_file_04
#sed -i '/flavor=/c flavor=keystone'                                                                   $conf_file_04

exit 0
