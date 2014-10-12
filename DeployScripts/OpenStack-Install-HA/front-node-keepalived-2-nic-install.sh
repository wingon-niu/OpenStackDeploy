#!/bin/bash

source ./env.sh

apt-get install -y keepalived

#Modify conf file of keepalived
CONF_FILE=/etc/keepalived/keepalived.conf
touch $CONF_FILE
./backup-file.sh $CONF_FILE

echo ""                                                                       > $CONF_FILE
echo "global_defs {"                                                         >> $CONF_FILE
echo "    notification_email {"                                              >> $CONF_FILE
echo "        $KEEPALIVED_NOTIFY_EMAIL"                                      >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    notification_email_from root@$NODE_HOST_NAME_FQDN"                 >> $CONF_FILE
echo "    smtp_server 127.0.0.1"                                             >> $CONF_FILE
echo "    smtp_connect_timeout 30"                                           >> $CONF_FILE
echo "    router_id $KEEPALIVED_ROUTER_ID"                                   >> $CONF_FILE
echo "}"                                                                     >> $CONF_FILE
echo ""                                                                      >> $CONF_FILE
echo "vrrp_sync_group VG_1 {"                                                >> $CONF_FILE
echo "    group {"                                                           >> $CONF_FILE
echo "        internal_net"                                                  >> $CONF_FILE
echo "        external_net"                                                  >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    smtp_alert"                                                        >> $CONF_FILE
echo "}"                                                                     >> $CONF_FILE
echo ""                                                                      >> $CONF_FILE
echo "vrrp_script check_haproxy {"                                           >> $CONF_FILE
echo "    script \"/etc/keepalived/check_haproxy.sh\""                       >> $CONF_FILE
echo "    interval 10"                                                       >> $CONF_FILE
echo "}"                                                                     >> $CONF_FILE
echo ""                                                                      >> $CONF_FILE
echo "vrrp_instance internal_net {"                                          >> $CONF_FILE
echo "    state $KEEPALIVED_STATE"                                           >> $CONF_FILE
echo "    interface $KEEPALIVED_INTERNAL_NET_INTERFACE_NAME"                 >> $CONF_FILE
#echo"    dont_track_primary"                                                >> $CONF_FILE
echo "    track_interface {"                                                 >> $CONF_FILE
echo "        $KEEPALIVED_INTERNAL_NET_INTERFACE_NAME"                       >> $CONF_FILE
echo "        $KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME"                       >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    virtual_router_id $KEEPALIVED_INTERNAL_NET_VIRTUAL_ROUTER_ID"      >> $CONF_FILE
echo "    priority $KEEPALIVED_INTERNAL_NET_PRIORITY"                        >> $CONF_FILE
echo "    advert_int 1"                                                      >> $CONF_FILE
echo "    authentication {"                                                  >> $CONF_FILE
echo "        auth_type PASS"                                                >> $CONF_FILE
echo "        auth_pass paswrd123"                                           >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    virtual_ipaddress {"                                               >> $CONF_FILE
echo "        $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP/24 dev $KEEPALIVED_INTERNAL_NET_INTERFACE_NAME label $KEEPALIVED_INTERNAL_NET_INTERFACE_NAME:ka" >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "}"                                                                     >> $CONF_FILE
echo ""                                                                      >> $CONF_FILE
echo "vrrp_instance external_net {"                                          >> $CONF_FILE
echo "    state $KEEPALIVED_STATE"                                           >> $CONF_FILE
echo "    interface $KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME"                 >> $CONF_FILE
#echo"    dont_track_primary"                                                >> $CONF_FILE
echo "    track_interface {"                                                 >> $CONF_FILE
echo "        $KEEPALIVED_INTERNAL_NET_INTERFACE_NAME"                       >> $CONF_FILE
echo "        $KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME"                       >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    virtual_router_id $KEEPALIVED_EXTERNAL_NET_VIRTUAL_ROUTER_ID"      >> $CONF_FILE
echo "    priority $KEEPALIVED_EXTERNAL_NET_PRIORITY"                        >> $CONF_FILE
echo "    advert_int 1"                                                      >> $CONF_FILE
echo "    authentication {"                                                  >> $CONF_FILE
echo "        auth_type PASS"                                                >> $CONF_FILE
echo "        auth_pass paswrd123"                                           >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    virtual_ipaddress {"                                               >> $CONF_FILE
echo "        $KEEPALIVED_EXTERNAL_NET_VIRTUAL_IP/24 dev $KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME label $KEEPALIVED_EXTERNAL_NET_INTERFACE_NAME:ka" >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "    track_script {"                                                    >> $CONF_FILE
echo "        check_haproxy"                                                 >> $CONF_FILE
echo "    }"                                                                 >> $CONF_FILE
echo "}"                                                                     >> $CONF_FILE
echo ""                                                                      >> $CONF_FILE

cp ./check_haproxy.sh /etc/keepalived/check_haproxy.sh
chmod a+x /etc/keepalived/check_haproxy.sh

#

exit 0
