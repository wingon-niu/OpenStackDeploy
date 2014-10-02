#!/bin/bash

source ./env.sh

service glance-api stop
service glance-registry stop

exit 0
