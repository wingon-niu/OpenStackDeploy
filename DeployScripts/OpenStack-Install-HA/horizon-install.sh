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

NUM=$(cat $CONF_FILE | grep ':11211' | wc -l)
if [ $NUM -eq 0 ]; then
    echo "ERROR: There is no memcached configuration in $CONF_FILE"
else
    sed -i "s/.*:11211.*/       'LOCATION' : '$CONTROLLER_NODE_MANAGEMENT_IP:11211',/g" $CONF_FILE
fi

#Modify /etc/memcached.conf
CONF_FILE=/etc/memcached.conf
./backup-file.sh $CONF_FILE

sed -i "/^-l/d"      $CONF_FILE
echo ""           >> $CONF_FILE
echo "-l 0.0.0.0" >> $CONF_FILE
echo ""           >> $CONF_FILE

#Reload Apache and memcached
service apache2 restart
service memcached restart

#

echo "End time of horizon-install:"
date

exit 0
