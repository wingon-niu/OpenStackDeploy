#!/bin/bash

source ./env.sh

#if [ $# -ne 1 ]; then
#    echo 'Error: miss hostname.'
#    echo 'Usage: command your-hostname'
#    exit 1
#fi

HOST_NAME=$NODE_HOST_NAME
HOST_NAME_FQDN=$NODE_HOST_NAME_FQDN

hostname $HOST_NAME

CONF_FILE=/etc/hostname
./backup-file.sh $CONF_FILE
echo $HOST_NAME > $CONF_FILE

CONF_FILE=/etc/hosts
./backup-file.sh $CONF_FILE
COUNT=$(cat $CONF_FILE | grep '^127.0.0.1' | wc -l)
if [ $COUNT -ne 0 ]; then
    sed -i "/^127.0.0.1/c 127.0.0.1    localhost"                      $CONF_FILE
else
    echo ""                       >> $CONF_FILE
    echo "127.0.0.1    localhost" >> $CONF_FILE
fi
COUNT=$(cat $CONF_FILE | grep '^127.0.1.1' | wc -l)
if [ $COUNT -ne 0 ]; then
    sed -i "/^127.0.1.1/c 127.0.1.1    $HOST_NAME_FQDN    $HOST_NAME"  $CONF_FILE
else
    echo ""                                                         >> $CONF_FILE
    echo "127.0.1.1    $HOST_NAME_FQDN    $HOST_NAME"               >> $CONF_FILE
fi

CONF_FILE=/etc/resolvconf/resolv.conf.d/head
./backup-file.sh $CONF_FILE
echo "nameserver $MY_DNS1"         >  $CONF_FILE
echo "nameserver $MY_DNS2"        >>  $CONF_FILE
service resolvconf restart

./backup-file.sh /etc/default/locale
cp ./node-locale.txt  /etc/default/locale
locale-gen --lang zh_CN.UTF-8

echo '------------------------------------------------------------'
echo '-------  hostname  -----------------------------------------'
hostname
echo '-------  hostname -f  --------------------------------------'
hostname -f
echo '-------  /etc/hostname  ------------------------------------'
cat /etc/hostname
echo '-------  /etc/hosts     ------------------------------------'
cat /etc/hosts
echo '-------  /etc/resolv.conf  ---------------------------------'
cat /etc/resolv.conf
echo '-------  locale  -------------------------------------------'
cat /etc/default/locale
echo '------------------------------------------------------------'
echo '------------------------------------------------------------'

exit 0
