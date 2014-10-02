#!/bin/bash

source ./env.sh

#Edit the eth2 in /etc/network/interfaces

conf_file_01=/etc/network/interfaces
./backup-file.sh $conf_file_01

sed -i '/^auto eth2/,$d' $conf_file_01

echo 'auto eth2'                                  >> $conf_file_01
echo 'iface eth2 inet manual'                     >> $conf_file_01
echo 'up ifconfig $IFACE 0.0.0.0 up'              >> $conf_file_01
echo 'up ip link set $IFACE promisc on'           >> $conf_file_01
echo 'down ip link set $IFACE promisc off'        >> $conf_file_01
echo 'down ifconfig $IFACE down'                  >> $conf_file_01


