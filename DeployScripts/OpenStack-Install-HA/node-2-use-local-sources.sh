#!/bin/bash

source ./env.sh

if [ $USE_OTHER_UBUNTU_APT_SOURCES = 'Yes' ]; then

    ./backup-file.sh                                           /etc/apt/sources.list
    rm                                                         /etc/apt/sources.list
    cp ./sources.list.sohu                                     /etc/apt/sources.list

    if [ $NEW_UBUNTU_APT_SOURCES != 'mirrors.sohu.com' ]; then
        ./backup-file.sh                                       /etc/apt/sources.list
        sed -i "s/mirrors.sohu.com/$NEW_UBUNTU_APT_SOURCES/g"  /etc/apt/sources.list
    fi
fi

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

exit 0
