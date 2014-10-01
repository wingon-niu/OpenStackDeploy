#!/bin/bash

FILE=$1
INTERVAL=$2

TMP_FILE=./ping-tmp.txt
rm -f $TMP_FILE

echo "------------------------------"

ALL_COUNT=$(cat $FILE | wc -l)

RUNNING_COUNT=0
while [ $RUNNING_COUNT -ne $ALL_COUNT ]; do
    RUNNING_COUNT=0
    for IP in $(cat $FILE); do
        ping -c 2 $IP 2>&1 | tee $TMP_FILE > /dev/null 2>&1
        N=$(cat $TMP_FILE | grep "64 bytes from $IP" | wc -l)
        if [ $N -eq 0 ]; then
            echo "can not ping $IP"            
        else
            echo "can ping $IP"
            ((RUNNING_COUNT++))
        fi
        rm -f $TMP_FILE
    done
    echo "------------------------------"

    if [ $RUNNING_COUNT -ne $ALL_COUNT ]; then
        echo "Test ping again after $INTERVAL seconds..."
        sleep $INTERVAL
    fi
done

RUNNING_COUNT=0
while [ $RUNNING_COUNT -ne $ALL_COUNT ]; do
    RUNNING_COUNT=0
    for IP in $(cat $FILE); do
        STR_SSH=$(ssh $IP "echo 'lightcloud'")
        if [ $STR_SSH = 'lightcloud' ]; then
            echo "can ssh $IP"            
            ((RUNNING_COUNT++))
        else
            echo "can not ssh $IP"
        fi
    done
    echo "------------------------------"

    if [ $RUNNING_COUNT -ne $ALL_COUNT ]; then
        echo "Test ssh again after $INTERVAL seconds..."
        sleep $INTERVAL
    fi
done

echo "All servers are now running."

exit 0
