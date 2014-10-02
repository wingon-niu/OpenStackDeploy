#!/bin/bash

source ./env.sh

#Restart the cinder services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls cinder-* ); do service $i restart; done; cd $current_dir;
service cinder-scheduler stop
service cinder-api stop
service cinder-volume stop
service tgt stop

exit 0
