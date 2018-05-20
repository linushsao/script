#!/bin/bash

#OUTIF="wlp3s0"
OUTIF="enp2s0"
INIF="wlx74da38b92029"
ESSID="Linuslab-AP"
PASSWD="0726072652"

killall hostapd; sleep 1
ifconfig $OUTIF up ; sleep 1

systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

/home/linuslab/Downloads/src/create_ap/create_ap $INIF $OUTIF $ESSID $PASSWD 

