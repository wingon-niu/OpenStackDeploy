#!/bin/bash

source ./env.sh

mysql -uroot -p$MYSQL_ROOT_PASSWORD keystone -e "delete from endpoint;"

###./make-creds.sh
###source ./openrc
###
###for id in $(keystone endpoint-list | grep regionOne | awk '{print $2}'); do
###    keystone endpoint-delete $id
###done

exit 0
