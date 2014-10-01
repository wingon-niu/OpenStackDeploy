#!/bin/bash

DST_PATH=$1
FILE_NAME_R_PART=$2

MY_FILE_NAME=$(ls -l $DST_PATH/*-$FILE_NAME_R_PART | tail -n 1 | awk '{print $NF}' | awk -F'/' '{print $NF}')
MY_PREFIX=${MY_FILE_NAME:0:3}

echo $MY_PREFIX

exit 0
