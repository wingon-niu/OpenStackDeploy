#!/bin/bash

CMD_PATH=.
DST_PATH=./conf_orig
CONF_DEPLOY_DIR=./conf_deploy
MY_LOCALE=$($CMD_PATH/get-conf-data.sh ./locale.txt LOCALE)
if [ $MY_LOCALE = 'CN' ]; then
    source ./locale_cn.txt
else
    source ./locale_en.txt
fi

PREFIX_STORAGE=$($CMD_PATH/get-max-prefix.sh $DST_PATH Storage.txt)
sed   -i  "/^GLANCE_STORAGE=/d"      $DST_PATH/$PREFIX_STORAGE-Storage.txt
sed   -i  "/^CINDER_STORAGE=/d"      $DST_PATH/$PREFIX_STORAGE-Storage.txt
sed   -i  "/^NOVA_STORAGE=/d"        $DST_PATH/$PREFIX_STORAGE-Storage.txt
echo      "GLANCE_STORAGE=ceph"  >>  $DST_PATH/$PREFIX_STORAGE-Storage.txt
echo      "CINDER_STORAGE=ceph"  >>  $DST_PATH/$PREFIX_STORAGE-Storage.txt
echo      "NOVA_STORAGE=ceph"    >>  $DST_PATH/$PREFIX_STORAGE-Storage.txt

sed   -i  "/^GLANCE_STORAGE=/c GLANCE_STORAGE=ceph"  $DST_PATH/*-env.sh
sed   -i  "/^CINDER_STORAGE=/c CINDER_STORAGE=ceph"  $DST_PATH/*-env.sh
sed   -i  "/^NOVA_STORAGE=/c   NOVA_STORAGE=ceph"    $DST_PATH/*-env.sh

echo "Done, will auto install ceph when execute: ./deploy.sh"

#

exit 0
