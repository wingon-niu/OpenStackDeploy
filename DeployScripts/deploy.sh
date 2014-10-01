#!/bin/bash

CMD_PATH=.
RUN_DATE=$(date "+%Y-%m-%d-%H-%M-%S")

mkdir -p $CMD_PATH/log
$CMD_PATH/deploy-action.sh $RUN_DATE 2>&1 | tee $CMD_PATH/log/$RUN_DATE-deploy.log

exit 0
