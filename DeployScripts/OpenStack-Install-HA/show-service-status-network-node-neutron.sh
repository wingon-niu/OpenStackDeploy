#!/bin/bash

source ./env.sh

#Show Service Status
service neutron-plugin-openvswitch-agent status
service neutron-l3-agent status
service neutron-dhcp-agent status
service neutron-metadata-agent status

exit 0
