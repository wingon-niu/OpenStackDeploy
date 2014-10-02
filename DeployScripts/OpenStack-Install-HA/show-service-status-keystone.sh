#!/bin/bash

source ./env.sh

#Create a simple credential file and load it so you won't be bothered later
./make-creds.sh

#Load it
source ./openrc

#To test Keystone, we use a simple CLI command
keystone user-list
keystone role-list
keystone tenant-list
keystone service-list
keystone endpoint-list

service keystone status

exit 0
