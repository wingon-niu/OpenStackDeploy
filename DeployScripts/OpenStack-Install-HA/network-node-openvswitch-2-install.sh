#!/bin/bash

source ./env.sh

#Modify conf files
./network-node-openvswitch-2-modify-conf-files.sh

#Add the eth2 to the br-ex

#Internet connectivity will be lost after this step but this won't affect OpenStack's work
ovs-vsctl add-port br-ex eth2

#If you want to get internet connection back, you can assign the eth2's IP address to the br-ex in the /etc/network/interfaces file.

#


