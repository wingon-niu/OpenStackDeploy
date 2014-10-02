#!/bin/bash

source ./env.sh

#Install RabbitMQ
#apt-get install -y rabbitmq-server rabbitmq-plugins
apt-get install -y rabbitmq-server

#Wait 5 seconds
echo "Wait 5 seconds......"
sleep 5

#Stop RabbitMQ Server
rabbitmqctl stop

exit 0
