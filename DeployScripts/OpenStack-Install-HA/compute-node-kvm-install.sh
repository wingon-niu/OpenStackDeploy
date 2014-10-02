#!/bin/bash

source ./env.sh

#Make sure that your hardware enables virtualization
apt-get install -y cpu-checker
kvm-ok

#Install kvm and configure it
apt-get install -y kvm libvirt-bin pm-utils

#Edit the cgroup_device_acl array in the /etc/libvirt/qemu.conf

conf_file_01=/etc/libvirt/qemu.conf
./backup-file.sh $conf_file_01

sed -i '/^#cgroup_device_acl =/c cgroup_device_acl = ['                                                        $conf_file_01
sed -i 's/#    "\/dev\/null", "\/dev\/full", "\/dev\/zero",/    "\/dev\/null", "\/dev\/full", "\/dev\/zero",/' $conf_file_01
sed -i 's/#    "\/dev\/random", "\/dev\/urandom",/    "\/dev\/random", "\/dev\/urandom",/'                     $conf_file_01
sed -i 's/#    "\/dev\/ptmx", "\/dev\/kvm", "\/dev\/kqemu",/    "\/dev\/ptmx", "\/dev\/kvm", "\/dev\/kqemu",/' $conf_file_01
sed -i 's/#    "\/dev\/rtc","\/dev\/hpet"/    "\/dev\/rtc", "\/dev\/hpet","\/dev\/net\/tun"/'                  $conf_file_01
sed -i '/^#]/c ]'                                                                                              $conf_file_01

#Delete default virtual bridge
virsh net-destroy default
virsh net-undefine default

#Enable live migration by updating /etc/libvirt/libvirtd.conf

conf_file_02=/etc/libvirt/libvirtd.conf
./backup-file.sh $conf_file_02

sed -i '/^#listen_tls = 0/c listen_tls = 0' $conf_file_02
sed -i '/^#listen_tcp = 1/c listen_tcp = 1' $conf_file_02
sed -i '/^#auth_tcp = /c auth_tcp = "none"' $conf_file_02

#Edit libvirtd_opts variable in /etc/init/libvirt-bin.conf

conf_file_03=/etc/init/libvirt-bin.conf
./backup-file.sh $conf_file_03

sed -i '/^env libvirtd_opts=/c env libvirtd_opts="-d -l"' $conf_file_03

#Edit /etc/default/libvirt-bin

conf_file_04=/etc/default/libvirt-bin
./backup-file.sh $conf_file_04

sed -i '/^libvirtd_opts=/c libvirtd_opts="-d -l"' $conf_file_04

#Restart the libvirt service and dbus to load the new values
service dbus restart
service libvirt-bin restart

#


