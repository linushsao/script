#!/bin/bash
#

PATH_SCRIPT="/home/linus/script"
PATH_CONF="/home/linus/conf"
WIRELESS_INF="wlan0"

CHECK=`pidof wpa_supplicant`

if [ "${CHECK}"	 == "" ]; then
	ifconfig ${WIRELESS_INF} up ;sleep 0
	wpa_supplicant -c ${PATH_CONF}/wpa.conf -i ${WIRELESS_INF} -D nl80211 &
	sleep 1
	dhclient ${WIRELESS_INF} &
fi


