#!/bin/bash

#exit 0
MY_ID="CLEAR ROUTER"

EXTIF="enp2s0"
INIF="enx00e04b39d58c"
WIRELESSIF="wlp3s0"
WIRELESSIF1="wlx74da38b92029"
TO_NULL=">/dev/null 2>&1"
PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
LOCAL_NETWORK="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

#check if timer is on
        a=`cat ${PATH_LOG}/TIMER`
        if [ "$a" != "" ];then
		echo "TIMER is on,can't disable network"
                exit 0 
        fi

echo "[ENABLE HAVEGED...]"
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

#restart ethercard
echo "[DISALBE IP_FORWARD...]"
echo "0" > /proc/sys/net/ipv4/ip_forward

#ifconfig $INIF down

echo "" > /home/linus/log/STAT

/home/linus/script/switch_proxy.sh block_hard

#echo "[ENABLE TEMP AP...]"
#create TEMP_AP
#${PATH_SCRIPT}/kill_ap.sh hostapd
#sleep 1
#PASSWORD=`date +%F`
#/home/linus/script/my_log.sh " CLEAR ROUTER: ${PASSWORD}"
/home/linus/script/my_log.sh "[${MY_ID}] ENABLE"
#/home/linus/script/switch_proxy.sh block_hard

