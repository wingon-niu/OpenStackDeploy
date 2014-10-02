#!/bin/bash

source ./env.sh

#Restart nova-* services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done; cd $current_dir;

service nova-compute restart

if [ $NETWORK_API_CLASS = 'nova-network' ]; then
    service nova-network restart
    service nova-api-metadata restart
fi

exit 0
