#!/bin/bash

exit 0
D=`date +%F@%R`

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

echo "1" > /proc/sys/net/ipv4/ip_forward
#killall create_ap

