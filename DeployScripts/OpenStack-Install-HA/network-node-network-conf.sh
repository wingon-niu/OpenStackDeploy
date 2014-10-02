#!/bin/bash

source ./env.sh

conf_file=/etc/network/interfaces
./backup-file.sh $conf_file

#genarate network conf file

echo ""                                               > $conf_file
echo "auto lo"                                       >> $conf_file
echo "iface lo inet loopback"                        >> $conf_file
echo ""                                              >> $conf_file
echo "auto eth0"                                     >> $conf_file
echo "iface eth0 inet static"                        >> $conf_file
echo "address $NETWORK_NODE_MANAGEMENT_IP"           >> $conf_file
echo "netmask 255.255.255.0"                         >> $conf_file
echo ""                                              >> $conf_file
echo "auto eth1"                                     >> $conf_file
echo "iface eth1 inet static"                        >> $conf_file
echo "address $NETWORK_NODE_VM_NETWORK_IP"           >> $conf_file
echo "netmask 255.255.255.0"                         >> $conf_file
echo ""                                              >> $conf_file
echo "auto eth3"                                     >> $conf_file
echo "iface eth3 inet static"                        >> $conf_file
echo "address 192.168.11.35"                         >> $conf_file
echo "netmask 255.255.255.0"                         >> $conf_file
echo "gateway 192.168.11.1"                          >> $conf_file
echo ""                                              >> $conf_file
echo "#eth2 mast be the last one"                    >> $conf_file
echo "auto eth2"                                     >> $conf_file
echo "iface eth2 inet static"                        >> $conf_file
echo "address $NETWORK_NODE_EXTERNAL_NET_IP"             >> $conf_file
echo "netmask 255.255.255.0"                         >> $conf_file

#restart the networking service
/etc/init.d/networking restart

