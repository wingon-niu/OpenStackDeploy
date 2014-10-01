#!/bin/bash

N=0
while [ $N -eq 0 ]; do
    N=$(screen -ls | grep "1 Socket in " | wc -l)
    sleep 2
done

exit 0
