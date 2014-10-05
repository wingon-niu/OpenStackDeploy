#!/bin/bash

source ./env.sh

#Make creds and source it
./make-creds.sh
source ./openrc

#Show Service Status
#---#glance image-list

service glance-api status
service glance-registry status

exit 0
