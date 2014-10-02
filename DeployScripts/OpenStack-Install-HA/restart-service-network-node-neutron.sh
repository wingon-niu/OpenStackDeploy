#!/bin/bash

source ./env.sh

#Restart Neutron
service neutron-plugin-openvswitch-agent restart
service neutron-l3-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart

exit 0
