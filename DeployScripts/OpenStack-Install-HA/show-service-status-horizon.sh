#!/bin/bash

source ./env.sh

service apache2 status
service memcached status

exit 0
