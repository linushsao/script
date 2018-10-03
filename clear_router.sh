#!/bin/bash

#exit 0

EXTIF="enp2s0"
INIF="enx00e04c3600d2"
WIRELESSIF="wlp3s0"

LOCAL_NETWORK="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo "[ENABLE HAVEGED...]"
systemctl stop haveged ;sleep 1
systemctl start haveged ;sleep 1 

#restart ethercard
echo "[RESTART ETHER_CARD...]"
#ifconfig $INIF down   ;sleep 1
#ifconfig $INIF 192.168.0.1 netmask 255.255.255.0 up ; sleep 1
#/home/linus/script/up_wlp3s0.sh ; sleep 1

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
/sbin/iptables -t mangle -F
/sbin/iptables -t mangle -X
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

echo "[DONE...]"

/home/linus/script/switch_proxy.sh block_hard

/home/linus/script/my_log.sh " CLEAR ROUTER..."
