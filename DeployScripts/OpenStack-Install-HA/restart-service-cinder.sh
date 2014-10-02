#!/bin/bash

source ./env.sh

#Restart the cinder services
#current_dir=`pwd`; cd /etc/init.d/; for i in $( ls cinder-* ); do service $i restart; done; cd $current_dir;
service cinder-scheduler restart
service cinder-api restart
service cinder-volume restart
service tgt restart

exit 0
