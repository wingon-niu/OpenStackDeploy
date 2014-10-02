#!/usr/bin/expect

#timeout = 2 days

set timeout 172800

spawn fdisk /dev/loop2

expect "Command (m for help):"
send "n\r"

expect "Select (default p):"
send "p\r"

expect "Partition number (1-4, default 1):"
send "1\r"

expect "):"
send "\r"

expect "):"
send "\r"

expect "Command (m for help):"
send "t\r"

expect "):"
send "8e\r"

expect "Command (m for help):"
send "w\r"

expect eof

