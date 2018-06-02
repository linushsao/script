#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="eth0"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""
SQUID_SERVER="127.0.0.1"
SQUID_PORT="8888"

echo "0" > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat
/sbin/iptables -P INPUT   DROP
/sbin/iptables -P OUTPUT  ACCEPT
/sbin/iptables -P FORWARD ACCEPT


