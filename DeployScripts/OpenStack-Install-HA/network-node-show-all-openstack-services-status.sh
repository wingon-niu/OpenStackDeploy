#!/bin/bash

source ./env.sh

#

if [ "$NETWORK_API_CLASS" = "neutron" ]; then

    ./show-service-status-network-node-neutron.sh 2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

elif [ "$NETWORK_API_CLASS" = "nova-network" ]; then

    ./show-service-status-nova-network.sh         2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

else
    DO_NOTHING="do_nothing"
fi

#

exit 0
