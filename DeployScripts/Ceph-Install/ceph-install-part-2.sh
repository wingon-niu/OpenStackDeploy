#!/bin/bash

HOST_NAME=$(hostname)
echo "Now running ceph-install-part-2.sh on $HOST_NAME"

for HOST_NAME in $(cat ./conf/ceph-client-hostname-info.txt | awk '{print $3}'); do
    ./check-ssh-connect.expect $HOST_NAME
done

for HOST_NAME in $(cat ./conf/ceph-server-hostname-info.txt | awk '{print $3}'); do
    ./check-ssh-connect.expect $HOST_NAME
done

#

#

exit 0
