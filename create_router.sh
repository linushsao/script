#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="eth0"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

#ifconfig $INIF 192.168.0.1 netmask 255.255.255.0 up ; sleep 1
echo "[ENABLE HAVEGED...]"
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

echo "1" > /proc/sys/net/ipv4/ip_forward
modprobe ip_tables
modprobe ip_nat_ftp
modprobe ip_nat_irc
modprobe ip_conntrack
modprobe ip_conntrack_ftp
modprobe ip_conntrack_irc
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat
/sbin/iptables -P INPUT   DROP
/sbin/iptables -P OUTPUT  ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -t nat -P PREROUTING  ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT
/sbin/iptables -t nat -P OUTPUT      ACCEPT

#允許本機往外連線
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#允許成為NAT
/sbin/iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o $EXTIF -j MASQUERADE

echo "[DONE...]"


