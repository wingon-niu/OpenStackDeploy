#!/bin/bash

source ./env.sh

apt-get install -y haproxy

#Modify conf file of haproxy
CONF_FILE=/etc/haproxy/haproxy.cfg
touch $CONF_FILE
./backup-file.sh $CONF_FILE

echo ""                                                                                              > $CONF_FILE
echo "global"                                                                                       >> $CONF_FILE
echo "    log     127.0.0.1 local0"                                                                 >> $CONF_FILE
echo "    maxconn 4000"                                                                             >> $CONF_FILE
echo "    chroot  /usr/share/haproxy"                                                               >> $CONF_FILE
echo "    daemon"                                                                                   >> $CONF_FILE
echo "    group   haproxy"                                                                          >> $CONF_FILE
echo "    pidfile /var/run/haproxy.pid"                                                             >> $CONF_FILE
echo "    user    haproxy"                                                                          >> $CONF_FILE
echo "    nbproc  4"                                                                                >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "defaults"                                                                                     >> $CONF_FILE
echo "    log      global"                                                                          >> $CONF_FILE
echo "    mode     tcp"                                                                             >> $CONF_FILE
echo "    maxconn  4000"                                                                            >> $CONF_FILE
echo "    option   redispatch"                                                                      >> $CONF_FILE
echo "    option   tcplog"                                                                          >> $CONF_FILE
echo "    option   dontlognull"                                                                     >> $CONF_FILE
echo "    option   abortonclose"                                                                    >> $CONF_FILE
echo "    retries  3"                                                                               >> $CONF_FILE
echo "    timeout  http-request 10s"                                                                >> $CONF_FILE
echo "    timeout  queue 1m"                                                                        >> $CONF_FILE
echo "    timeout  connect 10s"                                                                     >> $CONF_FILE
echo "    timeout  client 1m"                                                                       >> $CONF_FILE
echo "    timeout  server 1m"                                                                       >> $CONF_FILE
echo "    timeout  check 10s"                                                                       >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
###echo "listen dashboard_cluster_internal_ssl"                                                        >> $CONF_FILE
###echo "    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:443"                                          >> $CONF_FILE
###echo "    balance source"                                                                           >> $CONF_FILE
###echo "    mode    http"                                                                             >> $CONF_FILE
###echo "    option  httplog"                                                                          >> $CONF_FILE
###echo "    option  tcpka"                                                                            >> $CONF_FILE
###echo "    option  httpchk"                                                                          >> $CONF_FILE
###echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
###echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
###echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
###echo ""                                                                                             >> $CONF_FILE
###echo "listen dashboard_cluster_external_ssl"                                                        >> $CONF_FILE
###echo "    bind    $KEEPALIVED_EXTERNAL_NET_VIRTUAL_IP:443"                                          >> $CONF_FILE
echo "listen dashboard_cluster_ssl"                                                                 >> $CONF_FILE
echo "    bind    0.0.0.0:443"                                                                      >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    http"                                                                             >> $CONF_FILE
echo "    option  httplog"                                                                          >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:443 check inter 2000 rise 2 fall 5"   >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
###echo "listen dashboard_cluster_internal"                                                            >> $CONF_FILE
###echo "    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:80"                                           >> $CONF_FILE
###echo "    balance source"                                                                           >> $CONF_FILE
###echo "    mode    http"                                                                             >> $CONF_FILE
###echo "    option  httplog"                                                                          >> $CONF_FILE
###echo "    option  tcpka"                                                                            >> $CONF_FILE
###echo "    option  httpchk"                                                                          >> $CONF_FILE
###echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
###echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
###echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
###echo ""                                                                                             >> $CONF_FILE
###echo "listen dashboard_cluster_external"                                                            >> $CONF_FILE
###echo "    bind    $KEEPALIVED_EXTERNAL_NET_VIRTUAL_IP:80"                                           >> $CONF_FILE
echo "listen dashboard_cluster"                                                                     >> $CONF_FILE
echo "    bind    0.0.0.0:80"                                                                       >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    http"                                                                             >> $CONF_FILE
echo "    option  httplog"                                                                          >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:80 check inter 2000 rise 2 fall 5"    >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen galera_cluster"                                                                        >> $CONF_FILE
echo "    bind    0.0.0.0:3306"                                                                     >> $CONF_FILE
echo "    balance leastconn"                                                                        >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  mysql-check user haproxy_check"                                                   >> $CONF_FILE
echo "    default-server inter 2s downinter 5s rise 2 fall 5 slowstart 60s maxconn 512 maxqueue 256 weight 100" >> $CONF_FILE
echo "    server  controller3 $DB_NODE_03_IP:3306 check"                                            >> $CONF_FILE
echo "    server  controller2 $DB_NODE_02_IP:3306 check backup"                                     >> $CONF_FILE
echo "    server  controller1 $DB_NODE_01_IP:3306 check backup"                                     >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen glance_api_cluster"                                                                    >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:9292"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:9292"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:9292 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:9292 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:9292 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen glance_registry_cluster"                                                               >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:9191"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:9191"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
#echo"    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:9191 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:9191 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:9191 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen keystone_admin_cluster"                                                                >> $CONF_FILE
echo "    bind    0.0.0.0:35357"                                                                    >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:35357 check inter 2000 rise 2 fall 5" >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:35357 check inter 2000 rise 2 fall 5" >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:35357 check inter 2000 rise 2 fall 5" >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen keystone_public_internal_cluster"                                                      >> $CONF_FILE
#echo"    bind    $KEEPALIVED_EXTERNAL_NET_VIRTUAL_IP:5000"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:5000"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:5000 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:5000 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:5000 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen nova_ec2_api_cluster"                                                                  >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:8773"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:8773"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:8773 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:8773 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:8773 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen nova_compute_api_cluster"                                                              >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:8774"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:8774"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:8774 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:8774 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:8774 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen nova_metadata_api_cluster"                                                             >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:8775"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:8775"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:8775 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:8775 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:8775 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen cinder_api_cluster"                                                                    >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:8776"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:8776"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:8776 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:8776 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:8776 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen ceilometer_api_cluster"                                                                >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:8777"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:8777"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:8777 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:8777 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:8777 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen neutron_api_cluster"                                                                   >> $CONF_FILE
#echo"    bind    $KEEPALIVED_INTERNAL_NET_VIRTUAL_IP:9696"                                         >> $CONF_FILE
echo "    bind    0.0.0.0:9696"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    tcp"                                                                              >> $CONF_FILE
echo "    option  tcplog"                                                                           >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk"                                                                          >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:9696 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:9696 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:9696 check inter 2000 rise 2 fall 5"  >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen novnc_proxy_cluster"                                                                   >> $CONF_FILE
echo "    bind    0.0.0.0:6080"                                                                     >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
echo "    mode    http"                                                                             >> $CONF_FILE
echo "    option  httplog"                                                                          >> $CONF_FILE
echo "    option  tcpka"                                                                            >> $CONF_FILE
echo "    option  httpchk GET /vnc_auto.html"                                                       >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:6080 check inter 60000 rise 1 fall 1" >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:6080 check inter 60000 rise 1 fall 1" >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:6080 check inter 60000 rise 1 fall 1" >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE
echo "listen memcached_cluster"                                                                     >> $CONF_FILE
echo "    bind    0.0.0.0:11211"                                                                    >> $CONF_FILE
echo "    balance source"                                                                           >> $CONF_FILE
#echo"    mode    http"                                                                             >> $CONF_FILE
#echo"    option  httplog"                                                                          >> $CONF_FILE
#echo"    option  tcpka"                                                                            >> $CONF_FILE
#echo"    option  httpchk"                                                                          >> $CONF_FILE
echo "    default-server inter 2s downinter 5s rise 2 fall 5 slowstart 60s maxconn 10000 maxqueue 512 weight 100" >> $CONF_FILE
echo "    server  controller1 $CONTROLLER_NODE_01_INTERNAL_IP:11211 check"                          >> $CONF_FILE
echo "    server  controller2 $CONTROLLER_NODE_02_INTERNAL_IP:11211 check backup"                   >> $CONF_FILE
echo "    server  controller3 $CONTROLLER_NODE_03_INTERNAL_IP:11211 check backup"                   >> $CONF_FILE
echo ""                                                                                             >> $CONF_FILE

CONF_FILE=/etc/sysctl.conf
./backup-file.sh $CONF_FILE
sed -i '/^net.ipv4.ip_nonlocal_bind=1/d' $CONF_FILE
echo "net.ipv4.ip_nonlocal_bind=1"    >> $CONF_FILE
sysctl -p

CONF_FILE=/etc/default/haproxy
./backup-file.sh $CONF_FILE
sed -i "/^ENABLED=/c ENABLED=1" $CONF_FILE

CONF_FILE=/etc/rsyslog.d/haproxy.conf
echo ''                               > $CONF_FILE
echo '$ModLoad imudp'                >> $CONF_FILE
echo '$UDPServerRun 514'             >> $CONF_FILE
echo ''                              >> $CONF_FILE
echo 'local0.* /var/log/haproxy.log' >> $CONF_FILE

CONF_FILE=/etc/default/rsyslog
./backup-file.sh $CONF_FILE
sed -i '/^RSYSLOGD_OPTIONS=/c RSYSLOGD_OPTIONS="-r -c 5"' $CONF_FILE

mkdir -p /usr/share/haproxy
/etc/init.d/rsyslog restart

#

exit 0
