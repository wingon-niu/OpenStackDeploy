#!/bin/bash

source ./env.sh

#Install required packages
apt-get install -y libaio1 libssl0.9.8 mysql-client libdbd-mysql-perl libdbi-perl

#Install Galera wsrep provider
dpkg -i ./mysql_galera/galera-23.2.4-amd64.deb

#Install MySQL server with wsrep patch
dpkg -i ./mysql_galera/mysql-server-wsrep-5.5.28-23.7-amd64.deb

#I had some issues and I had to create /var/log/mysql
mkdir -pv /var/log/mysql
chown mysql:mysql -R /var/log/mysql

#Configure mysql to accept all incoming requests and disable name resolve
CONF_FILE=/etc/mysql/my.cnf
./backup-file.sh $CONF_FILE

sed -i 's/127.0.0.1/0.0.0.0/g'                     $CONF_FILE
sed -i '44 i skip-name-resolve'                    $CONF_FILE
sed -i '45 i log_bin=/var/log/mysql/mysql-bin.log' $CONF_FILE

#Restart Mysql and make sure you can connect to mysql server successfully
service mysql restart

while [ 1 -eq 1 ]
do
    echo "Wait 5 seconds......"
    sleep 5
    mysql -uroot -e "show databases;"
    if [ $? -eq 0 ]; then
        break
    fi
done

#Secure the mysql installation and assign a good password to root user
./database-mysql-secure-installation-expect.sh $MYSQL_ROOT_PASSWORD

#Grant privileges to SST account and delete empty users
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SET wsrep_on=OFF; DELETE FROM mysql.user WHERE user=''; GRANT ALL ON *.* TO wsrep_sst@'%' IDENTIFIED BY 'wspass123'; flush privileges;"

#Configure galera
CONF_FILE=/etc/mysql/conf.d/wsrep.cnf
./backup-file.sh $CONF_FILE

sed -i "/^wsrep_provider=/c wsrep_provider=/usr/lib/galera/libgalera_smm.so" $CONF_FILE
sed -i "/^wsrep_sst_auth=/c wsrep_sst_auth=wsrep_sst:wspass123"              $CONF_FILE
sed -i "/^#wsrep_node_address=/c wsrep_node_address=$DB_NODE_SELF_IP"        $CONF_FILE

./set-config.py $CONF_FILE mysqld query_cache_size         0
./set-config.py $CONF_FILE mysqld binlog_format            ROW
./set-config.py $CONF_FILE mysqld default_storage_engine   innodb
./set-config.py $CONF_FILE mysqld innodb_autoinc_lock_mode 2
./set-config.py $CONF_FILE mysqld innodb_doublewrite       1

#Restart mysql in cluster mode
./restart-service-mysql.sh

#Show service status mysql
echo "Wait 5 seconds......"
sleep 5
./show-service-status-mysql.sh

exit 0
