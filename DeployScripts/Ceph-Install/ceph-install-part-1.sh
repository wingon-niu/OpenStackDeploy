#!/bin/bash

HOST_NAME=$(hostname)
echo "Now running ceph-install-part-1.sh on $HOST_NAME"

apt-get -y install wget expect
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | apt-key add -
rm -f /etc/apt/sources.list.d/ceph.list
echo "deb http://ceph.com/debian-firefly/ trusty main" | tee /etc/apt/sources.list.d/ceph.list
apt-get -y update
apt-get -y install ceph-deploy

./gen-ssh-key.expect

#

exit 0
