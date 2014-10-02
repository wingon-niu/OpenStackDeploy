#!/bin/bash

source ./env.sh

service nova-network restart
service nova-api-metadata restart

exit 0
