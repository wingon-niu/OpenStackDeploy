#!/bin/bash

source ./env.sh

./restart-service-keystone.sh                    2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./restart-service-glance.sh                      2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./restart-service-cinder.sh                      2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./restart-service-horizon.sh                     2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'
./restart-service-nova-api.sh                    2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

if [ "$NETWORK_API_CLASS" = "neutron" ]; then

    ./restart-service-controller-node-neutron.sh 2>&1 | awk '{printf "    %-36s  %-17s  %-10s  %-10s\n",$1,$2,$3,$4}'

elif [ "$NETWORK_API_CLASS" = "nova-network" ]; then
    DO_NOTHING="do_nothing"
else
    DO_NOTHING="do_nothing"
fi

#

exit 0
