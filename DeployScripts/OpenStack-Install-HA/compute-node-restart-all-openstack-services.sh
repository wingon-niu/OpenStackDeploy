#!/bin/bash

source ./env.sh

#

if [ "$NETWORK_API_CLASS" = "neutron" ]; then

    ./restart-service-compute-node-neutron.sh 2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

elif [ "$NETWORK_API_CLASS" = "nova-network" ]; then
    DO_NOTHING="do_nothing"
else
    DO_NOTHING="do_nothing"
fi

./restart-service-nova-compute.sh             2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

#

exit 0
