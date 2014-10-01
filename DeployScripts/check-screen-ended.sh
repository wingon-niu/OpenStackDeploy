#!/bin/bash

N=0
while [ $N -eq 0 ]; do
    N=$(screen -ls | grep "No Sockets found in " | wc -l)
    printf "."
    sleep 5
done

printf "\n"

exit 0
