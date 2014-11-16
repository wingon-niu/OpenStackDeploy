#!/bin/bash

cd /root/OpenStack-Install-HA
source ./env.sh

if [ $(cat /etc/network/interfaces | grep br-ex | wc -l) -eq 0 ]; then
    exit 0
fi

#Edit /etc/network/interfaces
CONF_FILE=/etc/network/interfaces
./backup-file.sh $CONF_FILE

sed -i "/auto $EXTERNAL_NETWORK_INTERFACE_NAME/d"                  $CONF_FILE
sed -i "/iface $EXTERNAL_NETWORK_INTERFACE_NAME inet manual/d"     $CONF_FILE
sed -i '/up ifconfig $IFACE 0.0.0.0 up/d'                          $CONF_FILE
sed -i '/up ip link set $IFACE promisc on/d'                       $CONF_FILE
sed -i '/down ip link set $IFACE promisc off/d'                    $CONF_FILE
sed -i '/down ifconfig $IFACE down/d'                              $CONF_FILE

sed -i "s/auto br-ex/auto $EXTERNAL_NETWORK_INTERFACE_NAME/g"      $CONF_FILE
sed -i "s/iface br-ex/iface $EXTERNAL_NETWORK_INTERFACE_NAME/g"    $CONF_FILE

#

exit 0
