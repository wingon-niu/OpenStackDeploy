#!/bin/bash

source ./env.sh

if [ $DB_NODE_TYPE = 'FirstNode' ]; then
    echo "DB_NODE_TYPE === FirstNode"
    tmp_file=./tmp.sql

    echo ""                                                                                          > $tmp_file
    echo "DROP DATABASE IF EXISTS keystone;"                                                        >> $tmp_file
    echo "CREATE DATABASE keystone;"                                                                >> $tmp_file
    echo "GRANT ALL ON keystone.* TO '$KEYSTONE_USER'@'localhost' IDENTIFIED BY '$KEYSTONE_PASS';"  >> $tmp_file
    echo "GRANT ALL ON keystone.* TO '$KEYSTONE_USER'@'%'         IDENTIFIED BY '$KEYSTONE_PASS';"  >> $tmp_file
    echo ""                                                                                         >> $tmp_file
    echo "DROP DATABASE IF EXISTS glance;"                                                          >> $tmp_file
    echo "CREATE DATABASE glance;"                                                                  >> $tmp_file
    echo "GRANT ALL ON glance.*   TO '$GLANCE_USER'@'localhost'   IDENTIFIED BY '$GLANCE_PASS';"    >> $tmp_file
    echo "GRANT ALL ON glance.*   TO '$GLANCE_USER'@'%'           IDENTIFIED BY '$GLANCE_PASS';"    >> $tmp_file
    echo ""                                                                                         >> $tmp_file
    echo "DROP DATABASE IF EXISTS neutron;"                                                         >> $tmp_file
    echo "CREATE DATABASE neutron;"                                                                 >> $tmp_file
    echo "GRANT ALL ON neutron.*  TO '$NEUTRON_USER'@'localhost'  IDENTIFIED BY '$NEUTRON_PASS';"   >> $tmp_file
    echo "GRANT ALL ON neutron.*  TO '$NEUTRON_USER'@'%'          IDENTIFIED BY '$NEUTRON_PASS';"   >> $tmp_file
    echo ""                                                                                         >> $tmp_file
    echo "DROP DATABASE IF EXISTS nova;"                                                            >> $tmp_file
    echo "CREATE DATABASE nova;"                                                                    >> $tmp_file
    echo "GRANT ALL ON nova.*     TO '$NOVA_USER'@'localhost'     IDENTIFIED BY '$NOVA_PASS';"      >> $tmp_file
    echo "GRANT ALL ON nova.*     TO '$NOVA_USER'@'%'             IDENTIFIED BY '$NOVA_PASS';"      >> $tmp_file
    echo ""                                                                                         >> $tmp_file
    echo "DROP DATABASE IF EXISTS cinder;"                                                          >> $tmp_file
    echo "CREATE DATABASE cinder;"                                                                  >> $tmp_file
    echo "GRANT ALL ON cinder.*   TO '$CINDER_USER'@'localhost'   IDENTIFIED BY '$CINDER_PASS';"    >> $tmp_file
    echo "GRANT ALL ON cinder.*   TO '$CINDER_USER'@'%'           IDENTIFIED BY '$CINDER_PASS';"    >> $tmp_file
    echo ""                                                                                         >> $tmp_file
    echo "flush privileges;"                                                                        >> $tmp_file
    echo ""                                                                                         >> $tmp_file

    mysql -uroot -p$MYSQL_ROOT_PASSWORD -f < $tmp_file
    rm -f $tmp_file
else
    echo "DB_NODE_TYPE === FollowNode"
fi

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "INSERT INTO mysql.user(Host, User) values('localhost', 'haproxy_check');flush privileges;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "INSERT INTO mysql.user(Host, User) values('%',         'haproxy_check');flush privileges;"

#

exit 0
