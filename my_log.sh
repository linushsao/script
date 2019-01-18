#!/bin/bash

D=`date +%F@%R`
PATH_LOG="/home/linus/log"

if [ "${2}" == "" ]; then
echo $D" "$1 >> ${PATH_LOG}/.pass 
else
echo $D" "$1 >> ${PATH_LOG}/$2
fi
