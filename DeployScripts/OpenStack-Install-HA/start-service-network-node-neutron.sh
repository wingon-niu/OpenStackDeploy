#!/bin/bash

source ./env.sh

#Start Neutron
service neutron-plugin-openvswitch-agent start
service neutron-l3-agent start
service neutron-dhcp-agent start
service neutron-metadata-agent start

exit 0
