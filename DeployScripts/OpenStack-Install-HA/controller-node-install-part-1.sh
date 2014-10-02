#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-part-1-install:"
date

#Networking configuration before installation
#./controller-node-network-conf.sh

#Install MySQL and Galera
./database-install.sh

#Install RabbitMQ Part 1
./message-queue-install-part-1.sh

#------ Here ------

#

echo "End time of controller-node-part-1-install:"
date

exit 0
