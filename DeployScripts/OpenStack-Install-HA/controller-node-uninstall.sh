#!/bin/bash

source ./env.sh

MY_HOST_NAME=$(hostname)
echo "Now running controller node uninstall on $MY_HOST_NAME"

#Uninstall All OpenStack Components
./uninstall-all-openstack-components.sh
./cinder-volumes-remove.sh

#Uninstall RabbitMQ
./stop-service-rabbitmq.sh
apt-get -y remove     rabbitmq-server
apt-get -y autoremove rabbitmq-server --purge
rm -rf /var/lib/rabbitmq

#Uninstall Mysql Galera
./stop-service-mysql.sh
dpkg -r galera
dpkg -r mysql-server-wsrep
dpkg -P galera
dpkg -P mysql-server-wsrep
rm  -rf /var/lib/mysql
cp /etc/mysql/my.cnf.bak.100           /etc/mysql/my.cnf
cp /etc/mysql/conf.d/wsrep.cnf.bak.100 /etc/mysql/conf.d/wsrep.cnf

#

exit 0
