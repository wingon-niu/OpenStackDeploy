#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running controller node uninstall on $MY_HOST_NAME"

#

./uninstall-all-openstack-components.sh

#Uninstall RabbitMQ

#Uninstall Mysql Galera

#

exit 0
