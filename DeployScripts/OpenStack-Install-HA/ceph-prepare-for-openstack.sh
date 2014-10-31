#!/bin/bash

#Create Pools
#Here are a few values commonly used:
#Less than 5 OSDs       set pg_num to 128
#Between 5  and 10 OSDs set pg_num to 512
#Between 10 and 50 OSDs set pg_num to 4096
#If you have more than 50 OSDs, you need to understand the tradeoffs and how to calculate the pg_num value by yourself
#ceph osd pool create {pool-name} {pg-num} [{pgp-num}]
ceph osd pool create volumes 128 128
ceph osd pool create images  128 128
ceph osd pool create backups 128 128
ceph osd pool create vms     128 128

#SETUP CEPH CLIENT AUTHENTICATION
ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children,allow rwx pool=volumes,allow rwx pool=vms,allow rx pool=images'
ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children,allow rwx pool=images'
ceph auth get-or-create client.cinder-backup mon 'allow r' osd 'allow class-read object_prefix rbd_children,allow rwx pool=backups'

ceph auth get-or-create client.cinder        | tee /root/ceph.client.cinder.keyring
ceph auth get-or-create client.glance        | tee /root/ceph.client.glance.keyring
ceph auth get-or-create client.cinder-backup | tee /root/ceph.client.cinder-backup.keyring

ceph auth get-key client.cinder | tee /root/client.cinder.key
uuidgen                         | tee /root/uuid.txt
MY_UUID=$(cat /root/uuid.txt | awk '{print $1}')

echo "<secret ephemeral='no' private='no'>"      > /root/secret.xml
echo "  <uuid>$MY_UUID</uuid>"                  >> /root/secret.xml
echo "  <usage type='ceph'>"                    >> /root/secret.xml
echo "    <name>client.cinder secret</name>"    >> /root/secret.xml
echo "  </usage>"                               >> /root/secret.xml
echo "</secret>"                                >> /root/secret.xml

#

exit 0
