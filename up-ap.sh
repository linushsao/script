#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="wlp3s0"

ifconfig $INIF 192.168.100.1 

killall hostapd ; sleep 1
echo "[ENABLE HOSTAPD...]"
hostapd -dd /etc/hostapd/hostapd.conf ; sleep 1



