#!/bin/bash
#

#export network interface name
export My_ExtIF="enp4s0f2"
export My_InIF="enp0s20u2"
export My_Wireless1="wlp3s0"
export My_Wireless2="wlp0s20u1u3"

#My_ExtIF="wlp3s0"
#My_ExtIF="enp2s0"
INIF="${My_Wireless2}"
ESSID="Linuslab-AP"
PASSWD="0726072652"

killall hostapd; sleep 1
ifconfig $My_ExtIF up ; sleep 1
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

create_ap $INIF $My_ExtIF $ESSID $PASSWD 

