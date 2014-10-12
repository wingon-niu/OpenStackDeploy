#!/bin/bash

service neutron-openvswitch-agent restart

iptables -D INPUT -p udp -m multiport --dports 4789 -m comment --comment "vxlan incoming" -j ACCEPT
iptables -A INPUT -p udp -m multiport --dports 4789 -m comment --comment "vxlan incoming" -j ACCEPT

### There is no this "save" argument on ubuntu ?
### iptables save

exit 0
