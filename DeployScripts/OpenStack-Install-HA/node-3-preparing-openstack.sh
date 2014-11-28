#!/bin/bash

source ./env.sh

apt-get install -y ubuntu-cloud-keyring python-software-properties

rm -f               /etc/apt/sources.list.d/openstack.list
cp ./openstack.list /etc/apt/sources.list.d/

###echo "deb       http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main"   >  /etc/apt/sources.list.d/cloudarchive-juno.list
###echo "# deb-src http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main"  >>  /etc/apt/sources.list.d/cloudarchive-juno.list

######add-apt-repository cloud-archive:juno

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

#

exit 0
