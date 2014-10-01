#!/bin/bash

MY_FILE=$1
MY_KEY=$2
MY_VALUE=$3

sed -i "/^$MY_KEY=/c $MY_KEY=$MY_VALUE" $MY_FILE

exit 0
