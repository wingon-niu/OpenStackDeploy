#!/bin/bash

source ./env.sh

creds_file=./openrc

echo "export OS_TENANT_NAME=admin"                                        > $creds_file
echo "export OS_USERNAME=admin"                                          >> $creds_file
echo "export OS_PASSWORD=$KEYSTONE_ADMIN_PASSWORD"                       >> $creds_file
echo "export OS_AUTH_URL=http://$KEYSTONE_EXT_HOST_IP:5000/v2.0/"        >> $creds_file

exit 0
