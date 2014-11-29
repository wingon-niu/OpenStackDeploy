#!/bin/bash

source ./env.sh

#Modify the /etc/nova/nova.conf
CONF_FILE=/etc/nova/nova.conf
./backup-file.sh $CONF_FILE

./set-config.py $CONF_FILE database           connection                    mysql://$NOVA_USER:$NOVA_PASS@$DATABASE_IP/nova
./set-config.py $CONF_FILE database           idle_timeout                  60
./set-config.py $CONF_FILE DEFAULT            rpc_backend                   rabbit
./set-config.py $CONF_FILE DEFAULT            rabbit_hosts                  $RABBIT_HOSTS
./set-config.py $CONF_FILE DEFAULT            rabbit_retry_interval         1
./set-config.py $CONF_FILE DEFAULT            rabbit_retry_backoff          2
./set-config.py $CONF_FILE DEFAULT            rabbit_max_retries            0
./set-config.py $CONF_FILE DEFAULT            rabbit_durable_queues         false
./set-config.py $CONF_FILE DEFAULT            rabbit_ha_queues              true
./set-config.py $CONF_FILE DEFAULT            my_ip                         $CONTROLLER_NODE_NOVA_MY_IP
./set-config.py $CONF_FILE DEFAULT            vncserver_listen              $CONTROLLER_NODE_VNCSERVER_LISTEN
./set-config.py $CONF_FILE DEFAULT            vncserver_proxyclient_address $CONTROLLER_NODE_VNCSERVER_PROXYCLIENT_ADDRESS
./set-config.py $CONF_FILE DEFAULT            auth_strategy                 keystone
./set-config.py $CONF_FILE keystone_authtoken auth_uri                      http://$KEYSTONE_EXT_HOST_IP:5000
./set-config.py $CONF_FILE keystone_authtoken auth_host                     $KEYSTONE_HOST_IP
./set-config.py $CONF_FILE keystone_authtoken auth_port                     35357
./set-config.py $CONF_FILE keystone_authtoken auth_protocol                 http
./set-config.py $CONF_FILE keystone_authtoken admin_tenant_name             service
./set-config.py $CONF_FILE keystone_authtoken admin_user                    nova
./set-config.py $CONF_FILE keystone_authtoken admin_password                $KEYSTONE_SERVICE_PASSWORD
./set-config.py $CONF_FILE DEFAULT            glance_host                   $GLANCE_HOST_IP
./set-config.py $CONF_FILE DEFAULT            memcached_servers             $CONTROLLER_NODE_MANAGEMENT_IP:11211

if [ $NETWORK_API_CLASS = 'nova-network' ]; then
    echo "NETWORK_API_CLASS = nova-network"

    ./set-config.py $CONF_FILE DEFAULT network_api_class  nova.network.api.API
    ./set-config.py $CONF_FILE DEFAULT security_group_api nova

elif [ $NETWORK_API_CLASS = 'neutron' ]; then
    echo "NETWORK_API_CLASS = neutron"

    ./set-config.py $CONF_FILE DEFAULT network_api_class                     nova.network.neutronv2.api.API
    ./set-config.py $CONF_FILE DEFAULT neutron_url                           http://$CONTROLLER_NODE_MANAGEMENT_IP:9696
    ./set-config.py $CONF_FILE DEFAULT neutron_auth_strategy                 keystone
    ./set-config.py $CONF_FILE DEFAULT neutron_admin_tenant_name             service
    ./set-config.py $CONF_FILE DEFAULT neutron_admin_username                neutron
    ./set-config.py $CONF_FILE DEFAULT neutron_admin_password                $KEYSTONE_SERVICE_PASSWORD
    ./set-config.py $CONF_FILE DEFAULT neutron_admin_auth_url                http://$KEYSTONE_HOST_IP:35357/v2.0
    ./set-config.py $CONF_FILE DEFAULT linuxnet_interface_driver             nova.network.linux_net.LinuxOVSInterfaceDriver
    ./set-config.py $CONF_FILE DEFAULT firewall_driver                       nova.virt.firewall.NoopFirewallDriver
    ./set-config.py $CONF_FILE DEFAULT security_group_api                    neutron
    ./set-config.py $CONF_FILE DEFAULT service_neutron_metadata_proxy        true
    ./set-config.py $CONF_FILE DEFAULT neutron_metadata_proxy_shared_secret  $METADATA_PROXY_SHARED_SECRET

    #
else
    echo "NETWORK_API_CLASS = unknown type"
fi

##Now modify authtoken section in the /etc/nova/api-paste.ini
#conf_file_01=/etc/nova/api-paste.ini
#./backup-file.sh $conf_file_01
#
#sed -i '/filter:authtoken/,$d' $conf_file_01
#echo "[filter:authtoken]"                                                                >> $conf_file_01
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_01
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_01
#echo "auth_port = 35357"                                                                 >> $conf_file_01
#echo "auth_protocol = http"                                                              >> $conf_file_01
#echo "admin_tenant_name = service"                                                       >> $conf_file_01
#echo "admin_user = nova"                                                                 >> $conf_file_01
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_01
#echo "signing_dirname = /tmp/keystone-signing-nova"                                      >> $conf_file_01
#echo "# Workaround for https://bugs.launchpad.net/nova/+bug/1154809"                     >> $conf_file_01
#echo "auth_version = v2.0"                                                               >> $conf_file_01
#
##Modify the /etc/nova/nova.conf
#conf_file_02=/etc/nova/nova.conf
#./backup-file.sh $conf_file_02
#
#sed -i '/DEFAULT/,$d' $conf_file_02
#echo "[DEFAULT]"                                                                                          >> $conf_file_02
#echo "logdir=/var/log/nova"                                                                               >> $conf_file_02
#echo "state_path=/var/lib/nova"                                                                           >> $conf_file_02
#echo "lock_path=/run/lock/nova"                                                                           >> $conf_file_02
#echo "verbose=True"                                                                                       >> $conf_file_02
#echo "api_paste_config=/etc/nova/api-paste.ini"                                                           >> $conf_file_02
#echo "compute_scheduler_driver=nova.scheduler.simple.SimpleScheduler"                                     >> $conf_file_02
#echo "rabbit_host=$MESSAGE_QUEUE_IP"                                                                      >> $conf_file_02
#echo "nova_url=http://$CONTROLLER_NODE_NOVA_URL_IP:8774/v1.1/"                                            >> $conf_file_02
#echo "sql_connection=mysql://$NOVA_USER:$NOVA_PASS@$DATABASE_IP/nova"                                     >> $conf_file_02
#echo "root_helper=sudo nova-rootwrap /etc/nova/rootwrap.conf"                                             >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Auth"                                                                                             >> $conf_file_02
#echo "use_deprecated_auth=false"                                                                          >> $conf_file_02
#echo "auth_strategy=keystone"                                                                             >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Imaging service"                                                                                  >> $conf_file_02
#echo "glance_api_servers=$GLANCE_HOST_IP:9292"                                                            >> $conf_file_02
#echo "image_service=nova.image.glance.GlanceImageService"                                                 >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Vnc configuration"                                                                                >> $conf_file_02
#echo "novnc_enabled=true"                                                                                 >> $conf_file_02
#echo "novncproxy_base_url=http://$CONTROLLER_NODE_NOVNCPROXY_BASE_URL_IP:6080/vnc_auto.html"              >> $conf_file_02
#echo "novncproxy_port=6080"                                                                               >> $conf_file_02
#echo "vncserver_proxyclient_address=$CONTROLLER_NODE_VNCSERVER_PROXYCLIENT_ADDRESS"                       >> $conf_file_02
#echo "vncserver_listen=0.0.0.0"                                                                           >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Network settings"                                                                                 >> $conf_file_02
#echo "network_api_class=nova.network.neutronv2.api.API"                                                   >> $conf_file_02
#echo "neutron_url=http://$CONTROLLER_NODE_NEUTRON_URL_IP:9696"                                            >> $conf_file_02
#echo "neutron_auth_strategy=keystone"                                                                     >> $conf_file_02
#echo "neutron_admin_tenant_name=service"                                                                  >> $conf_file_02
#echo "neutron_admin_username=neutron"                                                                     >> $conf_file_02
#echo "neutron_admin_password=$KEYSTONE_SERVICE_PASSWORD"                                                  >> $conf_file_02
#echo "neutron_admin_auth_url=http://$KEYSTONE_HOST_IP:35357/v2.0"                                         >> $conf_file_02
#echo "libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver"                              >> $conf_file_02
#echo "linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver"                           >> $conf_file_02
#echo "#If you want Neutron + Nova Security groups"                                                        >> $conf_file_02
#echo "firewall_driver=nova.virt.firewall.NoopFirewallDriver"                                              >> $conf_file_02
#echo "security_group_api=neutron"                                                                         >> $conf_file_02
#echo "#If you want Nova Security groups only, comment the two lines above and uncomment line -1-."        >> $conf_file_02
#echo "#-1-firewall_driver=nova.virt.libvirt.firewall.IptablesFirewallDriver"                              >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "#Metadata"                                                                                          >> $conf_file_02
#echo "service_neutron_metadata_proxy = True"                                                              >> $conf_file_02
#echo "neutron_metadata_proxy_shared_secret = helloOpenStack"                                              >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Compute #"                                                                                        >> $conf_file_02
#echo "compute_driver=libvirt.LibvirtDriver"                                                               >> $conf_file_02
#echo ""                                                                                                   >> $conf_file_02
#echo "# Cinder #"                                                                                         >> $conf_file_02
#echo "volume_api_class=nova.volume.cinder.API"                                                            >> $conf_file_02
#echo "osapi_volume_listen_port=5900"                                                                      >> $conf_file_02

exit 0
