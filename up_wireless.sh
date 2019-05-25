#!/bin/bash

if [ $1 == "help" ]; then
	echo "USAGE: INIF ESSID PASSWD..."
	exit 0
	echo ; echo
fi

echo "[INIT WPA...]
wpa_passphrase $2 $3 > /home/linus/script/now.conf
cat /home/linus/script/now.conf ; sleep 1

echp "[BRING AP UP...]"
INIF=$1
killall wpa_supplicant
rfkill unblock all;sleep 1
ifconfig $INIF up
wpa_supplicant -i $INIF -D wext -c /home/linus/script/now.conf &
sleep 1
dhclient -v $INIF &

