#!/bin/bash

source ./env.sh

echo "Begin time of horizon-install:"
date

#Install horizon
apt-get install -y apache2 memcached libapache2-mod-wsgi openstack-dashboard
apt-get remove -y --purge openstack-dashboard-ubuntu-theme

#Modify /etc/openstack-dashboard/local_settings.py
CONF_FILE=/etc/openstack-dashboard/local_settings.py
./backup-file.sh $CONF_FILE

sed -i "/^OPENSTACK_HOST/c OPENSTACK_HOST = \"$KEYSTONE_EXT_HOST_IP\"" $CONF_FILE

#Reload Apache and memcached
service apache2 restart
service memcached restart

#

echo "End time of horizon-install:"
date

exit 0
