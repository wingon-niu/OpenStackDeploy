#!/usr/bin/expect

#timeout = 2 days

set timeout 172800

set password [lindex $argv 0]

spawn mysql_secure_installation

expect "Enter current password for root"
send "\r"

expect "Set root password"
send "Y\r"

expect "New password"
send "$password\r"

expect "Re-enter new password"
send "$password\r"

expect "Remove anonymous users"
send "Y\r"

expect "Disallow root login remotely"
send "n\r"

expect "Remove test database and access to it"
send "Y\r"

expect "Reload privilege tables now"
send "Y\r"

expect eof

