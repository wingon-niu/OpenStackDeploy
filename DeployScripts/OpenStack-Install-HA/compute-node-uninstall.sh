#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running compute node uninstall on $MY_HOST_NAME"

#

./uninstall-all-openstack-components.sh

#

exit 0
