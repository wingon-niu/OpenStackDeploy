#!/bin/bash
source ./env.sh

echo "Restart all nova-* processes..."

proc_array=("nova-api-metadata" "nova-compute" "nova-network")

for proc in ${proc_array[@]}
do
    service $proc restart
done

echo "Done."

exit 0
