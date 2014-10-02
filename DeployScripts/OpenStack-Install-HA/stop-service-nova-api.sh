#!/bin/bash

source ./env.sh

#Restart nova-* services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done; cd $current_dir;

service nova-api stop
service nova-cert stop
service nova-consoleauth stop
service nova-scheduler stop
service nova-conductor stop
service nova-novncproxy stop

exit 0
