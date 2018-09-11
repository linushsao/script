#!/bin/bash

DTIME=`date +%F@%R`
PATH_LOG="/home/linus/log"

if [ "$1" != "" ];then  #MSG must be existed
	if [ "$2" != "" ];then
		PATH_LOG="$2"
	fi
fi

mkdir -p ${PATH_LOG}
echo "${DTIME} : $1 " >> ${PATH_LOG}/log.txt

