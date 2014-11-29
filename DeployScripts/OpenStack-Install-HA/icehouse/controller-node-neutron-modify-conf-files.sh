#!/bin/bash

source ./env.sh

#Modify the /etc/neutron/neutron.conf
CONF_FILE=/etc/neutron/neutron.conf
./backup-file.sh $CONF_FILE

./set-config.py $CONF_FILE database           connection                    mysql://$NEUTRON_USER:$NEUTRON_PASS@$DATABASE_IP/neutron
./set-config.py $CONF_FILE database           idle_timeout                  60
./set-config.py $CONF_FILE DEFAULT            rpc_backend                   neutron.openstack.common.rpc.impl_kombu
./set-config.py $CONF_FILE DEFAULT            rabbit_hosts                  $RABBIT_HOSTS
./set-config.py $CONF_FILE DEFAULT            rabbit_retry_interval         1
./set-config.py $CONF_FILE DEFAULT            rabbit_retry_backoff          2
./set-config.py $CONF_FILE DEFAULT            rabbit_max_retries            0
./set-config.py $CONF_FILE DEFAULT            rabbit_durable_queues         false
./set-config.py $CONF_FILE DEFAULT            rabbit_ha_queues              true
./set-config.py $CONF_FILE DEFAULT            auth_strategy                 keystone
./set-config.py $CONF_FILE keystone_authtoken auth_uri                      http://$KEYSTONE_EXT_HOST_IP:5000
./set-config.py $CONF_FILE keystone_authtoken auth_host                     $KEYSTONE_HOST_IP
./set-config.py $CONF_FILE keystone_authtoken auth_port                     35357
./set-config.py $CONF_FILE keystone_authtoken auth_protocol                 http
./set-config.py $CONF_FILE keystone_authtoken admin_tenant_name             service
./set-config.py $CONF_FILE keystone_authtoken admin_user                    neutron
./set-config.py $CONF_FILE keystone_authtoken admin_password                $KEYSTONE_SERVICE_PASSWORD

./make-creds.sh
source ./openrc

SERVICE_TENANT_ID=$(keystone tenant-get service | grep ' id ' | awk '{print $4}')

./set-config.py $CONF_FILE DEFAULT            notify_nova_on_port_status_changes True
./set-config.py $CONF_FILE DEFAULT            notify_nova_on_port_data_changes   True
./set-config.py $CONF_FILE DEFAULT            nova_url                           http://$CONTROLLER_NODE_MANAGEMENT_IP:8774/v2
./set-config.py $CONF_FILE DEFAULT            nova_admin_username                nova
./set-config.py $CONF_FILE DEFAULT            nova_admin_tenant_id               $SERVICE_TENANT_ID
./set-config.py $CONF_FILE DEFAULT            nova_admin_password                $KEYSTONE_SERVICE_PASSWORD
./set-config.py $CONF_FILE DEFAULT            nova_admin_auth_url                http://$KEYSTONE_HOST_IP:35357/v2.0

./set-config.py $CONF_FILE DEFAULT            core_plugin                        $CORE_PLUGIN
./set-config.py $CONF_FILE DEFAULT            service_plugins                    $SERVICE_PLUGINS
./set-config.py $CONF_FILE DEFAULT            allow_overlapping_ips              $ALLOW_OVERLAPPING_IPS
./set-config.py $CONF_FILE DEFAULT            verbose                            $VERBOSE

#Modify the /etc/neutron/plugins/ml2/ml2_conf.ini
CONF_FILE=/etc/neutron/plugins/ml2/ml2_conf.ini
./backup-file.sh $CONF_FILE

if [ $TENANT_NETWORK_TYPES = 'gre' ]; then
    echo "TENANT_NETWORK_TYPES = gre"

    ./set-config.py $CONF_FILE ml2             type_drivers          gre
    ./set-config.py $CONF_FILE ml2             tenant_network_types  gre
    ./set-config.py $CONF_FILE ml2             mechanism_drivers     $MECHANISM_DRIVERS
    ./set-config.py $CONF_FILE ml2_type_gre    tunnel_id_ranges      1:10000

    #
elif [ $TENANT_NETWORK_TYPES = 'vxlan' ]; then
    echo "TENANT_NETWORK_TYPES = vxlan"

    ./set-config.py $CONF_FILE ml2             type_drivers          vxlan
    ./set-config.py $CONF_FILE ml2             tenant_network_types  vxlan
    ./set-config.py $CONF_FILE ml2             mechanism_drivers     $MECHANISM_DRIVERS
    ./set-config.py $CONF_FILE ml2_type_vxlan  vni_ranges            1000:5000
#   ./set-config.py $CONF_FILE ml2_type_vxlan  vxlan_group           239.1.1.1

    #
else
    echo "TENANT_NETWORK_TYPES = unknown type"
fi

./set-config.py $CONF_FILE securitygroup  firewall_driver        neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
./set-config.py $CONF_FILE securitygroup  enable_security_group  True

#./set-config.py $CONF_FILE DEFAULT            my_ip                         $CONTROLLER_NODE_NOVA_MY_IP
#./set-config.py $CONF_FILE DEFAULT            vncserver_listen              $CONTROLLER_NODE_VNCSERVER_LISTEN
#./set-config.py $CONF_FILE DEFAULT            vncserver_proxyclient_address $CONTROLLER_NODE_VNCSERVER_PROXYCLIENT_ADDRESS
#./set-config.py $CONF_FILE DEFAULT            glance_host                   $GLANCE_HOST_IP

##Edit the OVS plugin configuration file /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
#conf_file_01=/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
#./backup-file.sh $conf_file_01
#
#sed -i "/^sql_connection = /c sql_connection = mysql://$NEUTRON_USER:$NEUTRON_PASS@$DATABASE_IP/neutron"                   $conf_file_01
#sed -i "/^# Example: tenant_network_type/c tenant_network_type = gre"                                                      $conf_file_01
#sed -i "/^# Example: tunnel_id_ranges/c tunnel_id_ranges = 1:1000"                                                         $conf_file_01
#sed -i "/^# Default: enable_tunneling/c enable_tunneling = True"                                                           $conf_file_01
#sed -i "/^# firewall_driver = /c firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver"  $conf_file_01
#
##Edit /etc/neutron/api-paste.ini
#conf_file_02=/etc/neutron/api-paste.ini
#./backup-file.sh $conf_file_02
#
#sed -i "/filter:authtoken/d"     $conf_file_02
#sed -i "/paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory/d" $conf_file_02
#sed -i "/auth_host = /d"         $conf_file_02
#sed -i "/auth_port = /d"         $conf_file_02
#sed -i "/auth_protocol = /d"     $conf_file_02
#sed -i "/admin_tenant_name = /d" $conf_file_02
#sed -i "/admin_user = /d"        $conf_file_02
#sed -i "/admin_password = /d"    $conf_file_02
#
#echo ""                                                                                  >> $conf_file_02
#echo "[filter:authtoken]"                                                                >> $conf_file_02
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_02
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_02
#echo "auth_port = 35357"                                                                 >> $conf_file_02
#echo "auth_protocol = http"                                                              >> $conf_file_02
#echo "admin_tenant_name = service"                                                       >> $conf_file_02
#echo "admin_user = neutron"                                                              >> $conf_file_02
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_02
#
##Update the /etc/neutron/neutron.conf
#conf_file_03=/etc/neutron/neutron.conf
#./backup-file.sh $conf_file_03
#
#sed -i "/^# rabbit_host =/c rabbit_host = $MESSAGE_QUEUE_IP"     $conf_file_03
#sed -i "/^# rabbit_password = guest/c rabbit_password = guest"   $conf_file_03
#sed -i "/^# rabbit_port = 5672/c rabbit_port = 5672"             $conf_file_03
#sed -i "/^# rabbit_userid = guest/c rabbit_userid = guest"       $conf_file_03
#
#sed -i '/keystone_authtoken/,$d'                                 $conf_file_03
#
#echo "[keystone_authtoken]"                                   >> $conf_file_03
#echo "auth_host = $KEYSTONE_HOST_IP"                          >> $conf_file_03
#echo "auth_port = 35357"                                      >> $conf_file_03
#echo "auth_protocol = http"                                   >> $conf_file_03
#echo "admin_tenant_name = service"                            >> $conf_file_03
#echo "admin_user = neutron"                                   >> $conf_file_03
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"            >> $conf_file_03
#echo "signing_dir = /var/lib/neutron/keystone-signing"        >> $conf_file_03

exit 0
