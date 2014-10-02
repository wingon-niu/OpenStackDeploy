#!/bin/bash

source ./env.sh

#Stop Neutron
service neutron-plugin-openvswitch-agent stop

exit 0
