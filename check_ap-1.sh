#!/bin/bash


#exit 0

PARAM="Linuslab-AP"

c1=`ps -aux | grep ${PARAM}`
echo $c1


if [ "$c1" == "" ];then
/home/linus/script/run-nat-filter-reset-1.sh
fi


