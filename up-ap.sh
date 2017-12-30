#!/bin/bash

#exit 0

ifconfig wlp3s0 192.168.0.1
systemctl stop hostapd
systemctl start hostapd
dhcpd wlp3s0

