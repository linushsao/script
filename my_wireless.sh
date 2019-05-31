#!/bin/bash

MY_ID="CREATE TEMP WIRELESS"

PASSWD=`date +%Y%m%d`
ESSID=$2
WIRELESS_IF=$1
TO_NULL=">/dev/null 2>&1"

if [ $1 == "help" ]; then
	echo "USAGE: WIRELESS_IF ESSID ..."
	exit 0
	echo ; echo
fi

wpa_passphrase ${ESSID} ${PASSWD} > /home/linus/script/now.conf

/home/linus/script/my_log.sh "[${MY_ID}] ${ESSID} ${PASSWD} ..."
#cat /home/linus/script/now.conf ; sleep 1
echp "[BRING AP UP...]"
killall wpa_supplicant
rfkill unblock all;sleep 1
ifconfig ${WIRELESS_IF} up
wpa_supplicant -i ${WIRELESS_IF} -D wext -c /home/linus/script/now.conf &
sleep 1
dhclient -v ${WIRELESS_IF} &


