#!/bin/bash

source ./env.sh

service glance-api start
service glance-registry start

exit 0
