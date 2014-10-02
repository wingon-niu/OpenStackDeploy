#!/bin/bash

source ./env.sh

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "show status like 'wsrep%';"

exit 0
