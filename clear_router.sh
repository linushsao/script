#!/bin/bash

#exit 0
#export network interface name
EXTIF="enp2s0"
INIF="enx00e04c3600d2"
WIRELESSIF="wlp3s0"

#INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo "1" > /proc/sys/net/ipv4/ip_forward

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

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i $WIRELESSIF -j ACCEPT

#允許本機往外連線
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#允許本機服務開啟
iptables -A INPUT -p TCP -i $EXTIF --dport 80 -j ACCEPT # HTTP
iptables -A INPUT -p UDP -i $EXTIF --dport 80 -j ACCEPT
iptables -A INPUT -p TCP -i $WIRELESSIF --dport 20 -j ACCEPT # FTP
iptables -A INPUT -p UDP -i $WIRELESSIF --dport 20 -j ACCEPT
iptables -A INPUT -p TCP -i $WIRELESSIF --dport 21 -j ACCEPT 
iptables -A INPUT -p UDP -i $WIRELESSIF --dport 21 -j ACCEPT

iptables -A INPUT -p TCP -i $EXTIF --dport 443 -j ACCEPT # SSH
iptables -A INPUT -p UDP -i $EXTIF --dport 443 -j ACCEPT
iptables -A INPUT -p TCP -i $EXTIF --dport 30016 -j ACCEPT # MINETESTSERVER
iptables -A INPUT -p UDP -i $EXTIF --dport 30016 -j ACCEPT
iptables -A INPUT -p TCP -i $EXTIF --dport 30000 -j ACCEPT # MINETESTSERVER
iptables -A INPUT -p UDP -i $EXTIF --dport 30000 -j ACCEPT
iptables -A INPUT -p TCP -i $WIRELESSIF --dport 3128 -j ACCEPT   #PROXY
iptables -A INPUT -p UDP -i $WIRELESSIF --dport 3128 -j ACCEPT
iptables -A INPUT -p TCP -i $EXTIF --dport 8080 -j ACCEPT   #MOTION
iptables -A INPUT -p UDP -i $EXTIF --dport 8080 -j ACCEPT

#其他主機導向proxy
#iptables -t nat -A PREROUTING -i $My_InIF  -p tcp --dport 80 -j REDIRECT --to-port 3128 
#iptables -t nat -A PREROUTING -i $My_InIF  -p tcp --dport 443 -j REDIRECT --to-port 3128

/home/linus/script/my_log.sh " CLEAN ROUTER..."  

#cd /etc/tinyproxy
#cp tinyproxy.conf.nowhitelist tinyproxy.conf
#systemctl stop tinyproxy
#systemctl start tinyproxy
 
/home/linus/script/switch_proxy.sh block_hard

echo "[DONE...]"


