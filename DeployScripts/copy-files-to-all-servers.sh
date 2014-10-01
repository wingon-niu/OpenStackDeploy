#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
RUN_DATE=$1

$CMD_PATH/copy-files-to-all-servers-action.sh $RUN_DATE 2>&1 | tee $CMD_PATH/log/$RUN_DATE-copy-files-to-all-servers.log

exit 0
