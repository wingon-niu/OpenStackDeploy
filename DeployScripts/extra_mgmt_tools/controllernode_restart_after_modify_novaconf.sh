#!/bin/bash
source ./env.sh

echo "Restart all nova-* processes..."

proc_array=("nova-api" "nova-cert" "nova-conductor" "nova-consoleauth" "nova-novncproxy" "nova-scheduler")

for proc in ${proc_array[@]}
do
    service $proc restart
done

echo "Done."

exit 0
