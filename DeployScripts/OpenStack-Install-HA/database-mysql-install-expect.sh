#!/usr/bin/expect

#timeout = 2 days

set timeout 172800

set password [lindex $argv 0]

spawn apt-get install -y mysql-server python-mysqldb

expect "New password for the MySQL "
send "$password\r"

expect "Repeat password for the MySQL "
send "$password\r"

expect eof

