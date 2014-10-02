#!/bin/bash

source ./env.sh

#Check for the smiling faces on nova-* services
#nova-manage service list

service nova-compute status

if [ $NETWORK_API_CLASS = 'nova-network' ]; then
    service nova-network status
    service nova-api-metadata status
fi

exit 0
