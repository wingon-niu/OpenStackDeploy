#!/bin/bash

source ./env.sh

#Install networking components
apt-get install -y nova-common nova-network nova-api-metadata

#

exit 0
