#!/bin/bash

#exit 0

ifconfig wlp0s29u1u3 192.168.0.1

systemctl stop haveged 
systemctl start haveged 

killall hostapd
hostapd -dd /etc/hostapd/hostapd.conf

dhcpd wlp3s0

