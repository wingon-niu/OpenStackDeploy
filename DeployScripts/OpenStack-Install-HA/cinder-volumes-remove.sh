#!/bin/bash

source ./env.sh

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

vgremove cinder-volumes

pvremove /dev/loop2

rm $CINDER_VOLUMES_FILE

sed -i '/^losetup \/dev\/loop2 /d'               /etc/rc.local
sed -i '/pvcreate \/dev\/loop2/d'                /etc/rc.local
sed -i '/vgcreate cinder-volumes \/dev\/loop2/d' /etc/rc.local

losetup -d /dev/loop2

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
