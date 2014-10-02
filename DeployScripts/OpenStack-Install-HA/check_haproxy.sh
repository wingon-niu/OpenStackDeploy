#!/bin/bash

A=`ps -C haproxy --no-header | wc -l`

if [ $A -eq 0 ]; then
    /etc/init.d/haproxy start
    sleep 5
    if [ `ps -C haproxy --no-header | wc -l` -eq 0 ]; then
        /etc/init.d/keepalived stop
    fi
fi

exit 0
