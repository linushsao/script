#!/bin/bash

NAME_APP="My RandomPasswd"
USER="kids"
PASSWORD=`date | md5sum`
D=`date +%F@%R`
PATH_LOG="/home/linus/log/.pass"

/home/linus/script/my_log.sh "[${NAME_APP}] passwd:${PASSWORD}" 
echo "${USER}:${PASSWORD}" | chpasswd

