#!/bin/bash

source ./env.sh



if [ "$NETWORK_API_CLASS" = "neutron" ]; then
elif [ "$NETWORK_API_CLASS" = "nova-network" ]; then
else
fi

#

exit 0
