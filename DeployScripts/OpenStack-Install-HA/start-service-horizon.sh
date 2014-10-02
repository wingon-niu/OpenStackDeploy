#!/bin/bash

source ./env.sh

service apache2 start
service memcached start

exit 0
