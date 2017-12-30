#!/bin/bash


#exit 0
EXTIF="wlp0s20u2"
INIF="wlp3s0"
WIREIF="enp2s0f1"

ifconfig $EXTIF up
ifconfig $INIF up
ifconfig $WIREIF up

killall wpa_supplicant
D=`iwlist $EXTIF scanning | grep ESSID`
echo $D

c1=`echo $D | grep yfan`
echo $c1
c2=`echo $D | grep Linuslab`
echo $c2


if [ "$c1" != "" ];then

echo "Connect to YFAN ap..."
cd /home/linus/script
cp ./yfanap.conf now.conf
route del -net 192.168.43.0 netmask 255.255.255.0 device $EXTIF 
echo "COMPLETELY CONFIG SWITCH TO YfanAP..."
exit 0

fi

if [ "$c2" != "" ];then

echo "Connect to Linuslab ap..."
cd /home/linus/script
cp ./linusap.conf ./now.conf
route del -net 192.168.43.0 netmask 255.255.255.0 device $EXTIF
echo "COMPLETELY ONFIG SWITCH TO LinusAP..."
exit 0

fi




