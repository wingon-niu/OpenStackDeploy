#!/bin/bash

source ./env.sh

#apt-get install -y ubuntu-cloud-keyring
#echo "deb http://172.16.0.63/openstack precise-updates/icehouse main" > /etc/apt/sources.list.d/icehouse.list

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

exit 0
