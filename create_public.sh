#!/bin/bash

#exit 0

My_ExtIF="enp2s0"
My_InIF="enx00e04b39d58c"
My_Wireless1="wlp3s0"
My_Wireless2="wlx74da38b92029"

#restart ethercard
echo "[RESTART ETHER_CARD...]"
ifconfig $My_InIF down   ;sleep 1
ifconfig $My_InIF up     ;sleep 1
ifconfig $My_InIF 192.168.0.1 netmask 255.255.255.0 ; sleep 1

/home/linus/script/create_router.sh

/home/linus/script/switch_proxy.sh unblock
 
/home/linus/script/my_log.sh " Free Online Time..."

echo "ON" > /home/linus/log/STAT
