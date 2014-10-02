#!/bin/bash

source ./env.sh

#Install the openVSwitch
apt-get install -y openvswitch-switch openvswitch-datapath-dkms

#Create the bridges

#br-int will be used for VM integration
ovs-vsctl add-br br-int

#


