#!/bin/bash

source ./env.sh

echo "Begin time of glance-install:"
date

#Glance installation
apt-get install -y glance-common glance glance-api glance-registry python-glanceclient

if [ "$GLANCE_STORAGE" = "ceph" ]; then
    echo "GLANCE_STORAGE = ceph"
    apt-get install -y python-ceph
else
    echo "GLANCE_STORAGE = local_disk"
fi

#Modify conf files
$OPENSTACK_RELEASE/glance-modify-conf-files.sh

#Remove the SQLite database file
rm -f /var/lib/glance/glance.sqlite

#Restart Service Glance
./restart-service-glance.sh

if [ $FIRST_GLANCE_NODE = 'Yes' ]; then
    echo "FIRST_GLANCE_NODE = Yes"

    #Synchronize the glance database
    glance-manage db_sync

    #Make creds and source it
    #./make-creds.sh
    #source ./openrc

    #Upload images
    #glance image-create --name ubuntu14.04 --is-public true --container-format bare --disk-format qcow2 < ./images/precise-server-cloudimg-amd64-disk1.img
    #glance image-create --name centos6.5   --is-public true --container-format bare --disk-format qcow2 < ./images/centos-6.5-20140117.0.x86_64.qcow2
else
    echo "FIRST_GLANCE_NODE = No"
fi

#Show Service Status
./show-service-status-glance.sh

echo "End time of glance-install:"
date

exit 0
