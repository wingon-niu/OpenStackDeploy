#!/bin/bash

source ./env.sh

if [ $MQ_NODE_TYPE = 'FirstNode' ]; then
    echo "MQ_NODE_TYPE === FirstNode"
    service rabbitmq-server start
else
    echo "MQ_NODE_TYPE === FollowNode"
    service rabbitmq-server start
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@$MQ_NODE_01_HOST_NAME
    rabbitmqctl start_app
fi

rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'

exit 0
