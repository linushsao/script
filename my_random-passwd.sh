#!/bin/bash

USER="kids"
PASSWORD=`date | md5sum`
D=`date +%F@%R`
PATH_LOG="/home/linus/.pass"

echo $D" "$PASSWORD >> $PATH_LOG
echo "${USER}:${PASSWORD}" | chpasswd
