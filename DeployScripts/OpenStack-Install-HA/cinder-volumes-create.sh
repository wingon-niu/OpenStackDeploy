#!/bin/bash

source ./env.sh

dd if=/dev/zero of=$CINDER_VOLUMES_FILE bs=1 count=0 seek=$CINDER_VOLUMES_FILE_SIZE

losetup /dev/loop2 $CINDER_VOLUMES_FILE

pvcreate /dev/loop2

vgcreate cinder-volumes /dev/loop2

sed -i '/^exit 0/d'                               /etc/rc.local

echo "losetup /dev/loop2 $CINDER_VOLUMES_FILE" >> /etc/rc.local
echo "pvcreate /dev/loop2"                     >> /etc/rc.local
echo "vgcreate cinder-volumes /dev/loop2"      >> /etc/rc.local
echo ""                                        >> /etc/rc.local
echo "exit 0"                                  >> /etc/rc.local

./cinder-volumes-fdisk.expect.sh

echo "------------------------------------------------------------"
echo "------------------------------------------------------------"
ls -lh $CINDER_VOLUMES_FILE
losetup -a
pvdisplay
vgdisplay
cat /etc/rc.local
fdisk /dev/loop2 -l
echo "------------------------------------------------------------"
echo "------------------------------------------------------------"

exit 0
