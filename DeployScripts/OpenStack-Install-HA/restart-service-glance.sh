#!/bin/bash

source ./env.sh

#Restart the glance-api and glance-registry services
service glance-api restart
service glance-registry restart

exit 0
