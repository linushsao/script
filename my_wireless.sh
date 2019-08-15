#!/bin/bash

MY_ID="CREATE TEMP WIRELESS"

#PASSWD=`date +%Y%m%d`
PASSWD="20190814"
EXTIF=$2
INIF=$1
ESSID=$3

/home/linus/script/kill_ap.sh hostapd

/home/linus/script/my_log.sh "[${MY_ID}] ${ESSID} ${PASSWD} ..."
#cat /home/linus/script/now.conf ; sleep 1

create_ap $1 $2 $3 ${PASSWD} &
