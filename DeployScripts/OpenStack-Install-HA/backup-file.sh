#!/bin/bash

if [ $# -ne 1 ]; then
    echo 'backup-file.sh: wrong parameters.'
    exit 1
fi

if [ ! -e $1 ]; then
    echo 'backup-file.sh: file not exist.'
    exit 1
fi

MY_FILE=$1

if [ ! -e $MY_FILE.bak.100 ]; then
    cp $MY_FILE $MY_FILE.bak.100
    exit 0
fi

MY_STRING=`ls -l $MY_FILE.bak.* | tail -n 1 | awk '{print $NF}'`
MY_LEN=${#MY_STRING}
MY_NUMBER=${MY_STRING:MY_LEN-3:3}
((MY_NUMBER++))
cp $MY_FILE $MY_FILE.bak.$MY_NUMBER

exit 0
