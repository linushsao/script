#!/bin/bash

#exit 0

EXTIF="enp4s0f2"
INIF="enp0s20u2"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo "1" > /proc/sys/net/ipv4/ip_forward

/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat


