#!/bin/bash

USER="kids"
PASSWORD="apple2"
D=`date +%F@%R`
PATH_LOG="/home/linus/.pass"

echo $D" "$PASSWORD >> $PATH_LOG 
echo "${USER}:${PASSWORD}" | chpasswd


ifconfig eth0 down ; sleep 1

#cd /etc/tinyproxy/
#cp tinyproxy.conf.allow tinyproxy.conf
#/etc/init.d/tinyproxy restart

