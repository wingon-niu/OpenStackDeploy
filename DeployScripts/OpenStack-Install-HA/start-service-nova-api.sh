#!/bin/bash

source ./env.sh

#Restart nova-* services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done; cd $current_dir;

service nova-api start
service nova-cert start
service nova-consoleauth start
service nova-scheduler start
service nova-conductor start
service nova-novncproxy start

exit 0
