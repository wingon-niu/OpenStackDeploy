#!/bin/bash

source ./env.sh

NUM=5

echo ""
echo "network-node-install"
echo ""
echo "Sleep $NUM seconds, then exit."

I=1
for ((I=1; I<=$NUM; I++)); do
    printf "%12s\n" $I
    sleep 1
done

if [ $NETWORK_API_CLASS = 'neutron' ]; then
    shutdown -r now
fi
