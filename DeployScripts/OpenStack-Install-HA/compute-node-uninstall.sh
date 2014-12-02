#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running compute node uninstall on $MY_HOST_NAME"

#

if [ -f ./uuid.txt ]; then
    virsh secret-undefine --secret $(cat ./uuid.txt | awk '{print $1}')
fi

./uninstall-all-openstack-components.sh

#

exit 0
