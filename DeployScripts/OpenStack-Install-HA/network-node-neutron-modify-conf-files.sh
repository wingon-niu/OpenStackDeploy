#!/bin/bash

source ./env.sh

#Modify the /etc/neutron/neutron.conf
CONF_FILE=/etc/neutron/neutron.conf
./backup-file.sh $CONF_FILE

#./set-config.py $CONF_FILE database          connection                    mysql://$NEUTRON_USER:$NEUTRON_PASS@$DATABASE_IP/neutron
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

./set-config.py $CONF_FILE DEFAULT            core_plugin                   $CORE_PLUGIN
./set-config.py $CONF_FILE DEFAULT            service_plugins               $SERVICE_PLUGINS
./set-config.py $CONF_FILE DEFAULT            allow_overlapping_ips         $ALLOW_OVERLAPPING_IPS
./set-config.py $CONF_FILE DEFAULT            verbose                       $VERBOSE

#To configure the Layer-3 (L3) agent
CONF_FILE=/etc/neutron/l3_agent.ini
./backup-file.sh $CONF_FILE

./set-config.py $CONF_FILE DEFAULT            interface_driver              neutron.agent.linux.interface.OVSInterfaceDriver
./set-config.py $CONF_FILE DEFAULT            use_namespaces                True
./set-config.py $CONF_FILE DEFAULT            verbose                       $VERBOSE

#To configure the DHCP agent
CONF_FILE=/etc/neutron/dhcp_agent.ini
./backup-file.sh $CONF_FILE

./set-config.py $CONF_FILE DEFAULT            interface_driver              neutron.agent.linux.interface.OVSInterfaceDriver
./set-config.py $CONF_FILE DEFAULT            dhcp_driver                   neutron.agent.linux.dhcp.Dnsmasq
./set-config.py $CONF_FILE DEFAULT            use_namespaces                True
./set-config.py $CONF_FILE DEFAULT            verbose                       $VERBOSE

#To configure the metadata agent
CONF_FILE=/etc/neutron/metadata_agent.ini
./backup-file.sh $CONF_FILE

./set-config.py $CONF_FILE DEFAULT            auth_url                      http://$KEYSTONE_EXT_HOST_IP:5000/v2.0
./set-config.py $CONF_FILE DEFAULT            auth_region                   regionOne
./set-config.py $CONF_FILE DEFAULT            admin_tenant_name             service
./set-config.py $CONF_FILE DEFAULT            admin_user                    neutron
./set-config.py $CONF_FILE DEFAULT            admin_password                $KEYSTONE_SERVICE_PASSWORD
./set-config.py $CONF_FILE DEFAULT            nova_metadata_ip              $CONTROLLER_NODE_MANAGEMENT_IP
./set-config.py $CONF_FILE DEFAULT            metadata_proxy_shared_secret  $METADATA_PROXY_SHARED_SECRET
./set-config.py $CONF_FILE DEFAULT            verbose                       $VERBOSE

#To configure the Modular Layer 2 (ML2) plug-in
CONF_FILE=/etc/neutron/plugins/ml2/ml2_conf.ini
./backup-file.sh $CONF_FILE

if [ $TENANT_NETWORK_TYPES = 'gre' ]; then
    echo "TENANT_NETWORK_TYPES = gre"

    ./set-config.py $CONF_FILE ml2             type_drivers          gre
    ./set-config.py $CONF_FILE ml2             tenant_network_types  gre
    ./set-config.py $CONF_FILE ml2             mechanism_drivers     $MECHANISM_DRIVERS
    ./set-config.py $CONF_FILE ml2_type_gre    tunnel_id_ranges      1:10000

    ./set-config.py $CONF_FILE ovs             local_ip              $INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS
    ./set-config.py $CONF_FILE ovs             tunnel_type           gre
    ./set-config.py $CONF_FILE ovs             enable_tunneling      True

    #
elif [ $TENANT_NETWORK_TYPES = 'vxlan' ]; then
    echo "TENANT_NETWORK_TYPES = vxlan"

    ./set-config.py $CONF_FILE ml2             type_drivers          vxlan
    ./set-config.py $CONF_FILE ml2             tenant_network_types  vxlan
    ./set-config.py $CONF_FILE ml2             mechanism_drivers     $MECHANISM_DRIVERS
    ./set-config.py $CONF_FILE ml2_type_vxlan  vni_ranges            1000:5000
#   ./set-config.py $CONF_FILE ml2_type_vxlan  vxlan_group           239.1.1.1

    ./set-config.py $CONF_FILE ovs             local_ip              $INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS
    ./set-config.py $CONF_FILE ovs             tunnel_type           vxlan
    ./set-config.py $CONF_FILE ovs             enable_tunneling      True
    ./set-config.py $CONF_FILE ovs             vxlan_udp_port        4789

    #
else
    echo "TENANT_NETWORK_TYPES = unknown type"
fi

./set-config.py $CONF_FILE securitygroup  firewall_driver        neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
./set-config.py $CONF_FILE securitygroup  enable_security_group  True



##Edit /etc/neutron/api-paste.ini
#
#conf_file_01=/etc/neutron/api-paste.ini
#./backup-file.sh $conf_file_01
#
#sed -i "/filter:authtoken/d"                                                                   $conf_file_01
#sed -i "/^paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory/d"        $conf_file_01
#sed -i "/^auth_host = /d"                                                                      $conf_file_01
#sed -i "/^auth_port = /d"                                                                      $conf_file_01
#sed -i "/^auth_protocol = /d"                                                                  $conf_file_01
#sed -i "/^admin_tenant_name = /d"                                                              $conf_file_01
#sed -i "/^admin_user = /d"                                                                     $conf_file_01
#sed -i "/^admin_password = /d"                                                                 $conf_file_01
#
#echo ""                                                                                  >> $conf_file_01
#echo "[filter:authtoken]"                                                                >> $conf_file_01
#echo "paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory"        >> $conf_file_01
#echo "auth_host = $KEYSTONE_HOST_IP"                                                     >> $conf_file_01
#echo "auth_port = 35357"                                                                 >> $conf_file_01
#echo "auth_protocol = http"                                                              >> $conf_file_01
#echo "admin_tenant_name = service"                                                       >> $conf_file_01
#echo "admin_user = neutron"                                                              >> $conf_file_01
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"                                       >> $conf_file_01
#
##Edit the OVS plugin configuration file /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
#
#conf_file_02=/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini
#./backup-file.sh $conf_file_02
#
#sed -i "/^sql_connection = /c sql_connection = mysql://$NEUTRON_USER:$NEUTRON_PASS@$DATABASE_IP/neutron"                         $conf_file_02
#sed -i "/^# Example: tenant_network_type = /c tenant_network_type = gre"                                                         $conf_file_02
#sed -i "/^# Example: tunnel_id_ranges = /c tunnel_id_ranges = 1:1000"                                                            $conf_file_02
#sed -i "/^# Default: integration_bridge = /c integration_bridge = br-int"                                                        $conf_file_02
#sed -i "/^# Default: tunnel_bridge = /c tunnel_bridge = br-tun"                                                                  $conf_file_02
#sed -i "/^# Default: local_ip =/c local_ip = $NETWORK_NODE_VM_NETWORK_IP"                                                        $conf_file_02
#sed -i "/^# Default: enable_tunneling = /c enable_tunneling = True"                                                              $conf_file_02
#sed -i "/^# firewall_driver = /c firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver"        $conf_file_02
#
##Update /etc/neutron/metadata_agent.ini
#
#conf_file_03=/etc/neutron/metadata_agent.ini
#./backup-file.sh $conf_file_03
#
#sed -i "/^auth_url = /c auth_url = http://$KEYSTONE_HOST_IP:35357/v2.0"                            $conf_file_03
#sed -i "/^auth_region = /c auth_region = RegionOne"                                                $conf_file_03
#sed -i "/^admin_tenant_name = /c admin_tenant_name = service"                                      $conf_file_03
#sed -i "/^admin_user = /c admin_user = neutron"                                                    $conf_file_03
#sed -i "/^admin_password = /c admin_password = $KEYSTONE_SERVICE_PASSWORD"                         $conf_file_03
#sed -i "/^# nova_metadata_ip = /c nova_metadata_ip = $NOVA_METADATA_IP"                            $conf_file_03
#sed -i "/^# nova_metadata_port = /c nova_metadata_port = 8775"                                     $conf_file_03
#sed -i "/^# metadata_proxy_shared_secret =/c metadata_proxy_shared_secret = helloOpenStack"        $conf_file_03
#
##Update /etc/neutron/neutron.conf
#
#conf_file_04=/etc/neutron/neutron.conf
#./backup-file.sh $conf_file_04
#
#sed -i "/^# rabbit_host = /c rabbit_host = $MESSAGE_QUEUE_IP"    $conf_file_04
#
#sed -i '/keystone_authtoken/,$d'                                 $conf_file_04
#
#echo "[keystone_authtoken]"                                   >> $conf_file_04
#echo "auth_host = $KEYSTONE_HOST_IP"                          >> $conf_file_04
#echo "auth_port = 35357"                                      >> $conf_file_04
#echo "auth_protocol = http"                                   >> $conf_file_04
#echo "admin_tenant_name = service"                            >> $conf_file_04
#echo "admin_user = neutron"                                   >> $conf_file_04
#echo "admin_password = $KEYSTONE_SERVICE_PASSWORD"            >> $conf_file_04
#echo "signing_dir = /var/lib/neutron/keystone-signing"        >> $conf_file_04
#
##Edit /etc/sudoers.d/neutron_sudoers to give it full access like this (This is unfortunatly mandatory)
#
#conf_file_05=/etc/sudoers.d/neutron_sudoers
#./backup-file.sh $conf_file_05
#
#sed -i "/^neutron ALL/c neutron ALL=NOPASSWD: ALL"  $conf_file_05

exit 0
