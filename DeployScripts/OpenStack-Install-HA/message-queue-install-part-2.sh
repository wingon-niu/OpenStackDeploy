#!/bin/bash

source ./env.sh

#Add hostname and ip to /etc/hosts
CONF_FILE=/etc/hosts
./backup-file.sh $CONF_FILE

echo ""                                          >>    $CONF_FILE
echo "# Used for message queue nodes."           >>    $CONF_FILE
echo "$MQ_NODE_01_IP $MQ_NODE_01_HOST_NAME"      >>    $CONF_FILE
echo "$MQ_NODE_02_IP $MQ_NODE_02_HOST_NAME"      >>    $CONF_FILE
echo "$MQ_NODE_03_IP $MQ_NODE_03_HOST_NAME"      >>    $CONF_FILE

#Create cluster
if [ $MQ_NODE_TYPE = 'FirstNode' ]; then
    echo "MQ_NODE_TYPE === FirstNode"
    #scp /var/lib/rabbitmq/.erlang.cookie root@$MQ_NODE_02_IP:/var/lib/rabbitmq/.erlang.cookie
    #scp /var/lib/rabbitmq/.erlang.cookie root@$MQ_NODE_03_IP:/var/lib/rabbitmq/.erlang.cookie
    service rabbitmq-server start
else
    echo "MQ_NODE_TYPE === FollowNode"
    service rabbitmq-server start
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@$MQ_NODE_01_HOST_NAME
    rabbitmqctl start_app
fi

#Wait 5 seconds
echo "Wait 5 seconds......"
sleep 5

#For RabbitMQ version 3
rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'

#Show status of cluster
./show-service-status-rabbitmq.sh

exit 0
