#!/bin/bash

FILE_NAME=$1
OTHER_INFO=$2

declare -a INFO_LIST

MY_INDEX=0
while read line
do
    server_info=$(echo $line | awk '{print $3}')
    INFO_LIST[$MY_INDEX]=${server_info}${OTHER_INFO}
    ((MY_INDEX++))
done < $FILE_NAME

echo ${INFO_LIST[*]}

exit 0
