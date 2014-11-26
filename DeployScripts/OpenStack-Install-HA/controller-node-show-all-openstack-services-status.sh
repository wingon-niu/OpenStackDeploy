#!/bin/bash

source ./env.sh

./show-service-status-keystone.sh                    2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./show-service-status-glance.sh                      2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./show-service-status-cinder.sh                      2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./show-service-status-horizon.sh                     2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./show-service-status-nova-api.sh                    2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

if [ "$NETWORK_API_CLASS" = "neutron" ]; then

    ./show-service-status-controller-node-neutron.sh 2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

elif [ "$NETWORK_API_CLASS" = "nova-network" ]; then
    DO_NOTHING="do_nothing"
else
    DO_NOTHING="do_nothing"
fi

#

exit 0
