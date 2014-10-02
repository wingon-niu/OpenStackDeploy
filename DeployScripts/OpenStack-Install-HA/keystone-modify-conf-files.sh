#!/bin/bash

source ./env.sh

CONF_FILE=/etc/keystone/keystone.conf
./backup-file.sh $CONF_FILE

#sed -i "/admin_token = /c admin_token = $KEYSTONE_ADMIN_TOKEN"                                      $CONF_FILE
#sed -i "/^connection = /c connection = mysql://$KEYSTONE_USER:$KEYSTONE_PASS@$DATABASE_IP/keystone" $CONF_FILE

./set-config.py $CONF_FILE DEFAULT  admin_token  $KEYSTONE_ADMIN_TOKEN
./set-config.py $CONF_FILE DEFAULT  admin_port   35357
./set-config.py $CONF_FILE database connection   mysql://$KEYSTONE_USER:$KEYSTONE_PASS@$DATABASE_IP/keystone
./set-config.py $CONF_FILE signing  token_format UUID

exit 0
