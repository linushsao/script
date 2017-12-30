#!/bin/bash

#EXTIF="wlp3s0"
#INIF="wlp0s20u2"
NETWORK="1" # 1:wireless other:wired

if [ "$NETWORK" == "1" ];then
	EXTIF="wlp0s20u2"
	else
	EXTIF="enp2s0f1"
fi

INIF="wlp3s0"
INNET="192.168.10.0/24" # 若無內部網域介面，請填寫成 INNET=""
export EXTIF INIF INNET

if [ "$NETWORK" == "1" ];then
route del default
sleep 1
killall wpa_supplicant
sleep 1
wpa_supplicant -i $EXTIF -D wext -c /home/linus/script/now.conf &
sleep 1
dhclient -v $EXTIF

else
ifconfig enp2s0f1 124.10.81.127 netmask 255.255.255.0
route del default
route add default gw 124.10.81.254
fi


#exit 0
ifconfig $INIF 192.168.0.1
systemctl stop hostapd
systemctl start hostapd
killall dhcpd
sleep 1
dhcpd $INIF

# 2. 清除規則、設定預設政策及開放 lo 與相關的設定值
  PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH
  iptables -F
  iptables -X
  iptables -Z
  iptables -P INPUT   DROP
  iptables -P OUTPUT  ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# 清除 INTERFACE 所有佇列規則
tc qdisc del dev enp2s0f1 root 2>/dev/null
      iptables -A INPUT -i $INIF -j ACCEPT
      echo "1" > /proc/sys/net/ipv4/ip_forward
               iptables -t nat -A POSTROUTING  -o $EXTIF -j MASQUERADE
