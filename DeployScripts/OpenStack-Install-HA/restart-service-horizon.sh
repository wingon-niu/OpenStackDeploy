#!/bin/bash

source ./env.sh

service apache2 restart
service memcached restart

exit 0
