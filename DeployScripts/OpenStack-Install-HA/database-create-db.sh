#!/bin/bash

source ./env.sh

if [ $DB_NODE_TYPE = 'FirstNode' ]; then
    echo "DB_NODE_TYPE === FirstNode"

    tmp_file=./tmp.sql

    echo ""                                                                                               > $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "CREATE DATABASE keystone;"                                                                     >> $tmp_file
    echo "GRANT ALL ON keystone.* TO '$KEYSTONE_USER'@'%' IDENTIFIED BY '$KEYSTONE_PASS';"               >> $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "CREATE DATABASE glance;"                                                                       >> $tmp_file
    echo "GRANT ALL ON glance.* TO '$GLANCE_USER'@'%' IDENTIFIED BY '$GLANCE_PASS';"                     >> $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "CREATE DATABASE neutron;"                                                                      >> $tmp_file
    echo "GRANT ALL ON neutron.* TO '$NEUTRON_USER'@'%' IDENTIFIED BY '$NEUTRON_PASS';"                  >> $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "CREATE DATABASE nova;"                                                                         >> $tmp_file
    echo "GRANT ALL ON nova.* TO '$NOVA_USER'@'%' IDENTIFIED BY '$NOVA_PASS';"                           >> $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "CREATE DATABASE cinder;"                                                                       >> $tmp_file
    echo "GRANT ALL ON cinder.* TO '$CINDER_USER'@'%' IDENTIFIED BY '$CINDER_PASS';"                     >> $tmp_file
    echo ""                                                                                              >> $tmp_file
    echo "flush privileges;"                                                                             >> $tmp_file
    echo ""                                                                                              >> $tmp_file

    mysql -uroot -p$MYSQL_ROOT_PASSWORD < $tmp_file
    rm $tmp_file
else
    echo "DB_NODE_TYPE === FollowNode"
fi

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "INSERT INTO mysql.user(Host, User) values('%', 'haproxy_check');flush privileges;"

exit 0
