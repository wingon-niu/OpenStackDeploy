#!/bin/bash

source ./env.sh

mysql -uroot -p$MYSQL_ROOT_PASSWORD keystone -e "delete from assignment;delete from user;"

exit 0
