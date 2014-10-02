#!/bin/bash

#Install NTP service
apt-get install -y ntp

#Install other services
apt-get install -y vlan bridge-utils curl openssl expect build-essential vim python-setuptools python-iniparse python-psutil mysql-client python-mysqldb screen sysstat

#Enable IP_Forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

#To save you from rebooting, perform the following
sysctl net.ipv4.ip_forward=1

exit 0
