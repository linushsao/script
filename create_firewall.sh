#!/bin/bash

#exit 0

EXTIF="enp4s0f2"
INIF="enp0s20u2"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""
SQUID_SERVER="127.0.0.1"
SQUID_PORT="8888"

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

iptables -A INPUT -i $INIF -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

#允許本機往外連線
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#允許本機服務開啟
iptables -A INPUT -p TCP -i $EXTIF --dport 56565 -j ACCEPT # SSH
iptables -A INPUT -p UDP -i $EXTIF --dport 56565 -j ACCEPT


D=`date +%F@%R`
PATH_LOG="/home/linus/.pass"
echo $D" CREATE FIREWALL..."  >> $PATH_LOG 

echo "[DONE...]"


