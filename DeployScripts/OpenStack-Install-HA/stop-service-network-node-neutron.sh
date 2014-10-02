#!/bin/bash

source ./env.sh

#Stop Neutron
service neutron-plugin-openvswitch-agent stop
service neutron-l3-agent stop
service neutron-dhcp-agent stop
service neutron-metadata-agent stop

exit 0
