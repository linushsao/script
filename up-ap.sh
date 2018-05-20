#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="wlx74da38b92029"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

ifconfig $INIF 192.168.0.1

echo "[ENABLE HEAVEGED...]"
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 
killall dhcpd ;sleep 1
echo "[ENABLE DHCPD...]"
dhcpd $INIF -cf etc/dhcp/dhcpd.conf ;sleep 1

echo "[ENABLE MASQ...]"

	PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH
	iptables -F
	iptables -X
	iptables -Z
	iptables -P INPUT   DROP
	iptables -P OUTPUT  ACCEPT
	iptables -P FORWARD ACCEPT
	
	# 2. 清除 NAT table 的規則吧！
    iptables -F -t nat
    iptables -X -t nat
    iptables -Z -t nat
    iptables -t nat -P PREROUTING  ACCEPT
    iptables -t nat -P POSTROUTING ACCEPT
    iptables -t nat -P OUTPUT      ACCEPT

	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    echo "1" > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING  -o $EXTIF -j MASQUERADE	

killall hostapd ; sleep 1
echo "[ENABLE HOSTAPD...]"
hostapd -dd /etc/hostapd/hostapd.conf ; sleep 1



