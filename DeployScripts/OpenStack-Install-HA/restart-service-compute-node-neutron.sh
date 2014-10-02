#!/bin/bash

source ./env.sh

#Restart Neutron
service neutron-plugin-openvswitch-agent restart

exit 0
