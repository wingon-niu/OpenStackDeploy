#!/bin/bash

source ./env.sh

#if [ -f /root/node-prepared ]; then
#    echo "Node had been prepared."
#    exit 0
#fi

#Node init conf and common install
./node-1-server-init-conf.sh
./node-2-use-local-sources.sh
./node-3-preparing-openstack.sh
./node-4-common-install.sh

#touch /root/node-prepared

echo "Node prepared OK."

#Restart the Server
shutdown -r now
