#!/bin/bash

source ./env.sh

if [ $# -ne 1 ]; then
    echo "delete-keystone-service-endpoint.sh: wrong parameters."
    echo "Usage: delete-keystone-service-endpoint.sh service-name"
    exit 1
fi

MY_SERVICE_NAME=$1

./make-creds.sh
source ./openrc

if [ $(keystone service-list | grep " $MY_SERVICE_NAME " | grep -v grep | wc -l) -ne 0 ]; then
    MY_SERVICE_ID=$(keystone service-list | grep " $MY_SERVICE_NAME " | grep -v grep | awk '{print $2}')
    if [ $(keystone endpoint-list | grep $MY_SERVICE_ID | grep -v grep | wc -l) -ne 0 ]; then
        MY_ENDPOINT_ID=$(keystone endpoint-list | grep $MY_SERVICE_ID | grep -v grep | awk '{print $2}')
        keystone endpoint-delete $MY_ENDPOINT_ID
    else
        echo "Info: there is no endpoint of this service."
    fi
    keystone service-delete $MY_SERVICE_ID
else
    echo "Info: there is no this service name <$MY_SERVICE_NAME>"
fi

exit 0
