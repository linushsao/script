#!/bin/bash
#
#exit 0

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
CONF_DIR="/home/linus/conf"

EXTIF=`cat ${CONF_DIR}/EXTIF`
INIF=`cat ${CONF_DIR}/INIF`
WIRELESSIF=`cat ${CONF_DIR}/WIRELESSIF`
WIRELESSIF_1=`cat ${CONF_DIR}/WIRELESSIF_1`
AP_NAME="temp_ap"

#check for proxy
APP_PATH="/home/linus/src/tinyproxy/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d"
c1=`pidof tinyproxy`
#echo $c1
if [ "$c1" == "" ];then
  $APP_PATH
  /home/linus/script/my_log.sh "[RESUME PROXY...]"
fi

#check for temp_ap 
${PATH_SCRIPT}/kill_ap.sh iwlist
ifconfig ${WIRELESSIF} up;sleep 1
CHECK=`iwlist ${WIRELESSIF} scanning | grep ESSID | grep ${AP_NAME} `

if [ "${CHECK}" == "" ]; then
	killall hostapd
	ifconfig ${WIRELESSIF_1} up;sleep 1
	${PATH_SCRIPT}/my_wireless.sh ${WIRELESSIF_1} ${EXTIF} ${AP_NAME}
        /home/linus/script/my_log.sh "[RESUME TEMP_AP...]"
fi

#check for TCPDUMP
c1=`pidof tcpdump`
echo "TCPDUMP CHECK:"$c1
if [ "$c1" == "" ];then
  echo C1
  echo `date +%F@%R`  >> ${PATH_LOG}/TCPDUMP
#  tcpdump -w ${PATH_LOG}/pcap/`date +%d`.pcap -i ${INIF} 2>>${PATH_LOG}/TCPDUMP
  else
  /home/linus/script/my_log.sh "TCPDUMP was working" "TCPDUMP"
  echo C2
fi


#check for ADSL 
CHECK=`ifconfig | grep "124.11.64.47"`
if [ "$CHECK" == "" ];then
  /home/linus/script/up-adsl.sh
  /home/linus/script/my_log.sh "RESUME EXT INTERNET INTERFACE..."
fi

#check for INFERFACE
#CHECK=`ifconfig | grep "192.168.0.1"`
#if [ "$CHECK" == "" ];then
#  /home/linus/script/create_public.sh
#  /home/linus/script/my_log.sh "RESUME IN INTERNET INTERFACE..."
#fi
