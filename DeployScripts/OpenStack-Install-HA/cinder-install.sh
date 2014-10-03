#!/bin/bash

source ./env.sh

echo "Begin time of cinder-install:"
date

#Install the required packages
#apt-get install -y iscsitarget open-iscsi iscsitarget-dkms
apt-get install -y cinder-api cinder-scheduler
apt-get install -y lvm2 cinder-volume

#Configure the iscsi services
#sed -i 's/false/true/g' /etc/default/iscsitarget

#Restart the services
#service iscsitarget start
#service open-iscsi start

#Create a volumegroup and name it cinder-volumes
./cinder-volumes-create.sh

#Modify conf files
./cinder-modify-conf-files.sh

if [ $FIRST_CINDER_NODE = 'Yes' ]; then
    echo "FIRST_CINDER_NODE = Yes"

    #Synchronize database
    cinder-manage db sync

    #Create cinder v2 service and endpoint
    ./make-creds.sh
    source ./openrc
    keystone service-create --name=cinderv2 --type=volumev2 --description="OpenStack Block Storage v2"
    keystone endpoint-create \
        --service-id=$(keystone service-list | awk '/ volumev2 / {print $2}') \
        --publicurl=http://$KEYSTONE_EXT_HOST_IP:8776/v2/%\(tenant_id\)s \
        --internalurl=http://$KEYSTONE_HOST_IP:8776/v2/%\(tenant_id\)s \
        --adminurl=http://$KEYSTONE_HOST_IP:8776/v2/%\(tenant_id\)s
else
    echo "FIRST_CINDER_NODE = No"
fi

#Restart Service Cinder
./restart-service-cinder.sh

#Show Service Status
./show-service-status-cinder.sh

#

echo "End time of cinder-install:"
date

exit 0