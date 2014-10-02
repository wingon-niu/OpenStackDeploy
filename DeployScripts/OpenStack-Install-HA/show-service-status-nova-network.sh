#!/bin/bash

source ./env.sh

service nova-network status
service nova-api-metadata status

exit 0
