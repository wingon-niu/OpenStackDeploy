#!/bin/bash

source ./env.sh

#Restart the cinder services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls cinder-* ); do service $i restart; done; cd $current_dir;
service cinder-scheduler start
service cinder-api start
service cinder-volume start
service tgt start

exit 0
