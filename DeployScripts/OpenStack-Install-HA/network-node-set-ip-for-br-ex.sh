#!/bin/bash

cd /root/OpenStack-Install-HA
source ./env.sh

if [ $(cat /etc/network/interfaces | grep br-ex | wc -l) -ne 0 ]; then
    exit 0
fi

#Edit /etc/network/interfaces
CONF_FILE=/etc/network/interfaces
./backup-file.sh $CONF_FILE

sed -i "s/auto $EXTERNAL_NETWORK_INTERFACE_NAME/auto br-ex/g"   $CONF_FILE
sed -i "s/iface $EXTERNAL_NETWORK_INTERFACE_NAME/iface br-ex/g" $CONF_FILE

echo ""                                                      >> $CONF_FILE
echo "auto $EXTERNAL_NETWORK_INTERFACE_NAME"                 >> $CONF_FILE
echo "iface $EXTERNAL_NETWORK_INTERFACE_NAME inet manual"    >> $CONF_FILE
echo 'up ifconfig $IFACE 0.0.0.0 up'                         >> $CONF_FILE
echo 'up ip link set $IFACE promisc on'                      >> $CONF_FILE
echo 'down ip link set $IFACE promisc off'                   >> $CONF_FILE
echo 'down ifconfig $IFACE down'                             >> $CONF_FILE

#

exit 0
