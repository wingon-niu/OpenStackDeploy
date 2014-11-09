#!/bin/bash

source ./env.sh

echo "Begin time of keystone-install:"
date

#Install keystone packages
apt-get install -y keystone python-keystoneclient

#Modify conf files
./keystone-modify-conf-files.sh

#Remove the SQLite database file
rm -f /var/lib/keystone/keystone.db

#Restart the identity service then synchronize the database
service keystone restart

#Wait 2 seconds......
echo "Wait 2 seconds......"
sleep 2

if [ $FIRST_KEYSTONE_NODE = 'Yes' ]; then
    echo "FIRST_KEYSTONE_NODE = Yes"

    keystone-manage db_sync

    #Run init command
    ./keystone_basic.sh
    ./keystone_endpoints_basic.sh
else
    echo "FIRST_KEYSTONE_NODE = No"
fi

#Test Keystone
./show-service-status-keystone.sh

#

echo "End time of keystone-install:"
date

exit 0
