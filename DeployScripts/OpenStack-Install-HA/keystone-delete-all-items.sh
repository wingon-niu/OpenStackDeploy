#!/bin/bash

source ./env.sh

./keystone-delete-endpoints.sh
./keystone-delete-services.sh
./keystone-delete-users.sh
./keystone-delete-roles.sh
./keystone-delete-tenants.sh

exit 0
