#!/bin/bash

source ./env.sh

mysql -uroot -p$MYSQL_ROOT_PASSWORD keystone -e "delete from role;"

exit 0
