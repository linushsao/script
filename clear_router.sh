#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="enx00e04b39d58c"
WIRELESSIF="wlp3s0"
WIRELESSIF1="wlx74da38b92029"
TO_NULL=">/dev/null 2>&1"
PATH_SCRIPT="/home/linus/script"
LOCAL_NETWORK="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo "[ENABLE HAVEGED...]"
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

#restart ethercard
echo "[RESTART ETHER_CARD...]"

echo "1" > /proc/sys/net/ipv4/ip_forward
ifconfig $INIF down

echo "" > /home/linus/log/STAT

echo "[ENABLE TEMP AP...]"
#create TEMP_AP
${PATH_SCRIPT}/kill_ap.sh hostapd
sleep 1
PASSWORD=`date +%F`
/home/linus/script/my_log.sh " CLEAR ROUTER: ${PASSWORD}"
/home/linus/script/switch_proxy.sh block_hard

ifconfig ${WIRELESSIF1} down ; sleep 1
ifconfig ${WIRELESSIF1} up ; sleep 1
/home/linus/Downloads/create_ap/create_ap ${WIRELESSIF1} ${EXTIF} HarukiMurakami ${PASSWORD} >/dev/null 2>&1

