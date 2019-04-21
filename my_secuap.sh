#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="enx00e04b39d58c"
WIRELESSIF="wlp3s0"
WIRELESSIF1="wlx74da38b92029"
PATH_SCRIPT="/home/linus/script"
LOCAL_NETWORK="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo "1" > /proc/sys/net/ipv4/ip_forward

if [ $1 != "" ];then
	WIRELESSIF1=$1
        echo "RESET WIRELESS INTERFACE to ${1}..."	
	else
	echo "Bring Up TempAP with default ${WIRELESSIF1}..."
fi  	

echo "[DISALBE LINUSLAB-AP]"
ifconfig $INIF down

echo "[ENABLE TEMP AP...]"
#create TEMP_AP
${PATH_SCRIPT}/kill_ap.sh hostapd
sleep 1
PASSWORD=`date +%F`
${PATH_SCRIPT}/my_log.sh " TEMP AP PASSWD: ${PASSWORD}"

ifconfig ${WIRELESSIF1} down ; sleep 1
ifconfig ${WIRELESSIF1} up ; sleep 1
/home/linus/Downloads/create_ap/create_ap ${WIRELESSIF1} ${EXTIF} HarukiMurakami ${PASSWORD} >/dev/null 2>&1

