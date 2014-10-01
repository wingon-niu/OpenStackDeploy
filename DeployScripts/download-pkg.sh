#!/bin/bash

echo "Downloading Mysql and Galera packages, please wait ..."
wget -c -t 100 https://launchpad.net/galera/2.x/23.2.4/+download/galera-23.2.4-amd64.deb
wget -c -t 100 https://launchpad.net/codership-mysql/5.5/5.5.28-23.7/+download/mysql-server-wsrep-5.5.28-23.7-amd64.deb

echo "Downloading cirros image, please wait ..."
wget -c -t 100 http://download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img

mkdir -p ./mysql_galera
mkdir -p ./images

mv -f ./galera-23.2.4-amd64.deb                  ./mysql_galera/
mv -f ./mysql-server-wsrep-5.5.28-23.7-amd64.deb ./mysql_galera/
mv -f ./cirros-0.3.2-x86_64-disk.img             ./images/

ls -lh ./mysql_galera
ls -lh ./images

echo "Done."

exit 0
