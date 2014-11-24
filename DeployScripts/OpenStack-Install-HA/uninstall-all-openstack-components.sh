#!/bin/bash

#

ovs-vsctl del-br br-int
ovs-vsctl del-br br-tun
ovs-vsctl del-br br-ex

#

./stop-service-keystone.sh
./stop-service-glance.sh
./stop-service-cinder.sh
./stop-service-horizon.sh
./stop-service-nova-api.sh
./stop-service-nova-compute.sh
./stop-service-nova-network.sh
./stop-service-controller-node-neutron.sh
./stop-service-network-node-neutron.sh
./stop-service-compute-node-neutron.sh
service openvswitch-switch stop

#

apt-get -y remove \
           keystone python-keystoneclient \
           glance python-glanceclient \
           cinder-api cinder-scheduler python-cinderclient cinder-volume \
           openstack-dashboard apache2 libapache2-mod-wsgi memcached python-memcache \
           nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient \
           nova-compute \
           nova-network nova-api-metadata \
           neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent \
           neutron-server python-neutronclient

apt-get -y autoremove \
           keystone python-keystoneclient \
           glance python-glanceclient \
           cinder-api cinder-scheduler python-cinderclient cinder-volume \
           openstack-dashboard apache2 libapache2-mod-wsgi memcached python-memcache \
           nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient \
           nova-compute \
           nova-network nova-api-metadata \
           neutron-common neutron-plugin-ml2 neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent \
           neutron-server python-neutronclient \
           --purge

#

rm -rf /etc/keystone
rm -rf /etc/glance
rm -rf /etc/cinder
rm -rf /etc/openstack-dashboard
rm  -f /etc/memcached.conf
rm -rf /etc/nova
rm -rf /etc/neutron

#

exit 0
