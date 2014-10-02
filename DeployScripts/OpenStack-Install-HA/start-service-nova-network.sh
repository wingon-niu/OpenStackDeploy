#!/bin/bash

source ./env.sh

service nova-network start
service nova-api-metadata start

exit 0
