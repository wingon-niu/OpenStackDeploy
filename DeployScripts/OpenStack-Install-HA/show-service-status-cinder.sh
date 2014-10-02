#!/bin/bash

source ./env.sh

#Verify if cinder services are running
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls cinder-* ); do service $i status; done; cd $current_dir;
service cinder-scheduler status
service cinder-api status
service cinder-volume status
service tgt status

exit 0
