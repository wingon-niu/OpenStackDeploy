#!/bin/bash

MY_FILE=$1
MY_KEY=$2

cat $MY_FILE | grep "^$MY_KEY=" | awk -F'=' '{print $2}'

exit 0
