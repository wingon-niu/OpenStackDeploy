#!/bin/bash

source ./env.sh

CONF_FILE=/etc/mysql/conf.d/wsrep.cnf
./backup-file.sh    $CONF_FILE

if [ $DB_NODE_TYPE = 'FirstNode' ]; then
    echo "DB_NODE_TYPE === FirstNode"
    sed -i "/wsrep_cluster_address=/c wsrep_cluster_address=\"gcomm://\""                    $CONF_FILE
else
    echo "DB_NODE_TYPE === FollowNode"
    sed -i "/wsrep_cluster_address=/c wsrep_cluster_address=\"gcomm://$DB_NODE_01_IP:4567\"" $CONF_FILE
fi

service mysql start

exit 0
