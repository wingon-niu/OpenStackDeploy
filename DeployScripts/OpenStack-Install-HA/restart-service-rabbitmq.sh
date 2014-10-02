#!/bin/bash

source ./env.sh

./stop-service-rabbitmq.sh

echo "Wait 3 seconds..."
sleep 3

./start-service-rabbitmq.sh

exit 0
