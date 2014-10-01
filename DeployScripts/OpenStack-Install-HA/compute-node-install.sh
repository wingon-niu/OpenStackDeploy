#!/bin/bash

NUM=5

echo ""
echo "compute-node-install"
echo ""
echo "Sleep $NUM seconds, then exit."

I=1
for ((I=1; I<=$NUM; I++)); do
    printf "%12s\n" $I
    sleep 1
done

exit 0
