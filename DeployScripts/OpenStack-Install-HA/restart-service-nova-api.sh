#!/bin/bash

source ./env.sh

#Restart nova-* services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls nova-* ); do service $i restart; done; cd $current_dir;

service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

exit 0
