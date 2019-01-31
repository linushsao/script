#!/bin/bash
#
#exit 0

EXTIF="enp2s0"
INIF="enx00e04b39d58c"
WIRELESSIF0="wlp3s0"
WIRELESSIF1="wlx74da38b92029"
PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
AP_NAME="HarukiMurakami"

#check for proxy
APP_PATH="/home/linus/src/tinyproxy/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d"
c1=`pidof tinyproxy`
#echo $c1
if [ "$c1" == "" ];then
  $APP_PATH
  /home/linus/script/my_log.sh "[RESUME PROXY...]"
fi

#check for wireless
${PATH_SCRIPT}/kill_ap.sh iwlist
CHECK=`iwlist ${WIRELESSIF0} scanning | grep ESSID | grep ${AP_NAME} `
CHECK1=`cat /home/linus/log/STAT`
CHECK2=`ifconfig | grep ${INIF}`

/home/linus/script/my_log.sh  "CHECK ${AP_NAME} RESOULT: [${CHECK}]" "INIF_DOWN"
/home/linus/script/my_log.sh  "CHECK ${INIF} RESOULT: [${CHECK2}]"   "INIF_DOWN"

if [ "${CHECK1}" == "" ]; then
ifconfig $INIF down
/home/linus/script/my_log.sh "`date +%c`:${INIF} forced switch DOWN" "INIF_DOWN"
else
/home/linus/script/my_log.sh "`date +%c`:${INIF} allowed" "INIF_DOWN"
fi

#if [ "${CHECK}" == "" ] && [ "${CHECK1}" == "" ]; then
#${PATH_SCRIPT}/kill_ap.sh hostapd
#sleep 1
#PASSWORD=`date +%F`
#/home/linus/script/my_log.sh " RESUME ${AP_NAME} / PASSWORD: ${PASSWORD}"
#ifconfig ${WIRELESSIF1} down ; sleep 1
#ifconfig ${WIRELESSIF1} up ; sleep 1
#/home/linus/Downloads/create_ap/create_ap ${WIRELESSIF1} ${EXTIF} ${AP_NAME} ${PASSWORD}  >/dev/null 2>&1
#fi

#check for TCPDUMP
c1=`pidof tcpdump`
echo "TCPDUMP CHECK:"$c1
if [ "$c1" == "" ];then
  echo C1
  echo `date +%F@%R`  >> ${PATH_LOG}/TCPDUMP
  tcpdump -w ${PATH_LOG}/pcap/`date +%d`.pcap -i ${INIF} 2>>${PATH_LOG}/TCPDUMP
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
