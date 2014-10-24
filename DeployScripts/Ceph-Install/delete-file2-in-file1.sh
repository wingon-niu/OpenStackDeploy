#!/bin/bash

F1=$1
F2=$2

while read line
do
    sed -i "/$line/d" $F1
done < $F2

exit 0
