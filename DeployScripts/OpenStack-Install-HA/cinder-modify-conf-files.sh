#!/bin/bash

source ./env.sh

#Configure /etc/cinder/api-paste.ini
#conf_file_01=/etc/cinder/api-paste.ini
#./backup-file.sh $conf_file_01

#sed -i '/filter:authtoken/,$d' $conf_file_01
#echo "[filter:authtoken]"                                                                >> $conf_file_01
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_01
#echo "service_protocol = http"                                                           >> $conf_file_01
#echo "service_host = $KEYSTONE_EXT_HOST_IP"                                              >> $conf_file_01
#echo "service_port = 5000"                                                               >> $conf_file_01
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_01
#echo "auth_port = 35357"                                                                 >> $conf_file_01
#echo "auth_protocol = http"                                                              >> $conf_file_01
#echo "admin_tenant_name = service"                                                       >> $conf_file_01
#echo "admin_user = cinder"                                                               >> $conf_file_01
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_01
#echo "signing_dir = /var/lib/cinder"                                                     >> $conf_file_01

#Edit the /etc/cinder/cinder.conf
conf_file_02=/etc/cinder/cinder.conf
./backup-file.sh $conf_file_02

./set-config.py $conf_file_02 database           connection               mysql://$CINDER_USER:$CINDER_PASS@$DATABASE_IP/cinder
./set-config.py $conf_file_02 keystone_authtoken auth_uri                 http://$KEYSTONE_EXT_HOST_IP:5000
./set-config.py $conf_file_02 keystone_authtoken auth_host                $KEYSTONE_HOST_IP
./set-config.py $conf_file_02 keystone_authtoken auth_port                35357
./set-config.py $conf_file_02 keystone_authtoken auth_protocol            http
./set-config.py $conf_file_02 keystone_authtoken admin_tenant_name        service
./set-config.py $conf_file_02 keystone_authtoken admin_user               cinder
./set-config.py $conf_file_02 keystone_authtoken admin_password           $KEYSTONE_SERVICE_PASSWORD
./set-config.py $conf_file_02 DEFAULT            rpc_backend              cinder.openstack.common.rpc.impl_kombu
./set-config.py $conf_file_02 DEFAULT            rabbit_hosts             $RABBIT_HOSTS
./set-config.py $conf_file_02 DEFAULT            rabbit_retry_interval    1
./set-config.py $conf_file_02 DEFAULT            rabbit_retry_backoff     2
./set-config.py $conf_file_02 DEFAULT            rabbit_max_retries       0
./set-config.py $conf_file_02 DEFAULT            rabbit_durable_queues    false
./set-config.py $conf_file_02 DEFAULT            rabbit_ha_queues         true
./set-config.py $conf_file_02 DEFAULT            glance_host              $GLANCE_HOST_IP

#sed -i '/DEFAULT/,$d' $conf_file_02
#echo "[DEFAULT]"                                                                     >> $conf_file_02
#echo "rootwrap_config=/etc/cinder/rootwrap.conf"                                     >> $conf_file_02
#echo "sql_connection = mysql://$CINDER_USER:$CINDER_PASS@$DATABASE_IP/cinder"        >> $conf_file_02
#echo "api_paste_config = /etc/cinder/api-paste.ini"                                  >> $conf_file_02
#echo "iscsi_helper=ietadm"                                                           >> $conf_file_02
#echo "volume_name_template = volume-%s"                                              >> $conf_file_02
#echo "volume_group = cinder-volumes"                                                 >> $conf_file_02
#echo "verbose = True"                                                                >> $conf_file_02
#echo "auth_strategy = keystone"                                                      >> $conf_file_02
#echo "iscsi_ip_address=$CINDER_HOST_IP"                                              >> $conf_file_02
#echo "rabbit_host = $MESSAGE_QUEUE_IP"                                               >> $conf_file_02
#echo "rabbit_password = guest"                                                       >> $conf_file_02
#echo "rpc_backend = cinder.openstack.common.rpc.impl_kombu"                          >> $conf_file_02

exit 0
