#!/bin/bash

source ./env.sh

#Check for the smiling faces on nova-* services
#nova-manage service list

service nova-api status
service nova-cert status
service nova-consoleauth status
service nova-scheduler status
service nova-conductor status
service nova-novncproxy status

exit 0
