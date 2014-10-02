#!/bin/bash

source ./env.sh

echo "Begin time of controller-node-part-2-install:"
date

#Create these databases
./database-create-db.sh

#Install RabbitMQ Part 2
./message-queue-install-part-2.sh

#------ Here ------

#

echo "End time of controller-node-part-2-install:"
date

exit 0
