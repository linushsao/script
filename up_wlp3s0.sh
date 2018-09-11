#!/bin/bash

INIF=$1
killall wpa_supplicant
rfkill unblock all;sleep 1
ifconfig $INIF up
wpa_supplicant -i $INIF -D wext -c /home/linus/script/now.conf &
sleep 1
dhclient -v $INIF

