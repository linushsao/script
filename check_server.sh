#!/bin/bash
#
#exit 0


#check for proxy
APP_PATH="/home/linus/src/tinyproxy/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d"
c1=`pidof tinyproxy`
#echo $c1
if [ "$c1" == "" ];then
  $APP_PATH
  /home/linus/script/my_log.sh "[RESUME PROXY...]"
fi

#check for wireless
#CHECK=`ifconfig | grep "192.168.10.109" `
#if [ "$CHECK" == "" ];then
#  /home/linus/script/up_wireless.sh wlp3s0
#  /home/linus/script/my_log.sh "RESUME WIRELESS INTERFACE..."
#fi

#check for ADSL 
CHECK=`ifconfig | grep "124.11.64.47"`
if [ "$CHECK" == "" ];then
  /home/linus/script/up-adsl.sh
  /home/linus/script/my_log.sh "RESUME EXT INTERNET INTERFACE..."
fi

#check for INFERFACE
CHECK=`ifconfig | grep "192.168.0.1"`
if [ "$CHECK" == "" ];then
#  /home/linus/script/create_public.sh
#  /home/linus/script/my_log.sh "RESUME IN INTERNET INTERFACE..."
fi
