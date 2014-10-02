#!/bin/bash

source ./env.sh

./make-creds.sh
source ./openrc

my_str=$FLOATING_IP_ALLOCATION_POOLS
my_array=(${my_str//,/ })

echo "Delete Floating IPs..."

for data in ${my_array[@]}
do
    ip_begin=$(echo $data | awk -F'-' '{print $1}')
    ip_ended=$(echo $data | awk -F'-' '{print $2}')
    array_1=(${ip_begin//./ })
    array_2=(${ip_ended//./ })
    for ((i=${array_1[3]}; i<=${array_2[3]}; i++))
    do
        echo ${array_1[0]}.${array_1[1]}.${array_1[2]}.$i
        nova floating-ip-bulk-delete ${array_1[0]}.${array_1[1]}.${array_1[2]}.$i
    done
done

echo "Done."

exit 0
