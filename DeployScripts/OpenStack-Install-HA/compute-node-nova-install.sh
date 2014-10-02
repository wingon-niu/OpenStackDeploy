#!/bin/bash

source ./env.sh

echo "Begin time of compute-node-nova-install:"
date

#Install the Compute packages
if [ $COMPUTE_NODE_LIBVIRT_TYPE = 'kvm' ]; then
    echo "COMPUTE_NODE_LIBVIRT_TYPE = kvm"
    apt-get install -y nova-compute-kvm python-guestfs
elif [ $COMPUTE_NODE_LIBVIRT_TYPE = 'qemu' ]; then
    echo "COMPUTE_NODE_LIBVIRT_TYPE = qemu"
    apt-get install -y nova-compute-qemu python-guestfs
else
    echo "COMPUTE_NODE_LIBVIRT_TYPE = unknown type"
    apt-get install -y nova-compute python-guestfs
fi

#Make the current kernel readable
dpkg-statoverride  --update --add root root 0644 /boot/vmlinuz-$(uname -r)
cp ./statoverride /etc/kernel/postinst.d/statoverride
chmod +x /etc/kernel/postinst.d/statoverride

#Modify conf files
./compute-node-nova-modify-conf-files.sh

#Remove the SQLite database created by the packages
rm /var/lib/nova/nova.sqlite

#Restart the Compute service
./restart-service-nova-compute.sh

#Check service status
./show-service-status-nova-compute.sh

#

echo "End time of compute-node-nova-install:"
date

exit 0
