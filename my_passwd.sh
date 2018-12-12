#!/bin/bash

USER="kids"
PASSWORD="apple2"
D=`date +%F@%R`
PATH_LOG="/home/linus/.pass"

echo $D" "$PASSWORD >> $PATH_LOG 
echo "${USER}:${PASSWORD}" | chpasswd


/home/linus/script/my_log.sh " Recovery password..."
