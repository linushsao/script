#!/bin/bash

NAME_APP="My passwd"   
USER="kids"
PASSWORD="apple2"

PATH_LOG="/home/linus/log/.pass"
echo "${USER}:${PASSWORD}" | chpasswd

/home/linus/script/my_log.sh "[${NAME_APP}] passwd:${PASSWORD}"
