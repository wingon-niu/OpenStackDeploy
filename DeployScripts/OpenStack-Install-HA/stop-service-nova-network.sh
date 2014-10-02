#!/bin/bash

source ./env.sh

service nova-network stop
service nova-api-metadata stop

exit 0
