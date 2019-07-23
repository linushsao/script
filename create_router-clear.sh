#!/bin/bash

#exit 0
CONF_DIR="/home/linus/conf"

EXTIF=`cat ${CONF_DIR}/EXTIF`
INIF=`cat ${CONF_DIR}/INIF`
WIRELESSIF=`cat ${CONF_DIR}/WIRELESSIF`
WIRELESSIF_1=`cat ${CONF_DIR}/WIRELESSIF_1`

MINETESTSERVER_IP="192.168.12.134"
MINETESTSERVER_PORT="30016"
PROXY_PORT="8888"

IP_TEMPAP="192.168.12.1"
IP_LOCAL="192.168.0.1" 

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
iptables -A INPUT -i $WIRELESSIF_1 -j ACCEPT

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
iptables -A INPUT -p TCP -i $INIF --dport 443 -j ACCEPT # SSH
iptables -A INPUT -p UDP -i $INIF --dport 443 -j ACCEPT
#iptables -A INPUT -p TCP -i $EXTIF --dport 30016 -j ACCEPT # MINETESTSERVER
#iptables -A INPUT -p UDP -i $EXTIF --dport 30016 -j ACCEPT
#iptables -A INPUT -p TCP -i $EXTIF --dport 30000 -j ACCEPT # MINETESTSERVER
#iptables -A INPUT -p UDP -i $EXTIF --dport 30000 -j ACCEPT
iptables -A INPUT -p TCP -i $INIF  --dport ${PROXY_PORT} -j ACCEPT #PROXY   
iptables -A INPUT -p UDP -i $INIF  --dport ${PROXY_PORT} -j ACCEPT
iptables -A INPUT -p TCP -i ${WIRELESSIF_1}  --dport ${PROXY_PORT} -j ACCEPT #PROXY
iptables -A INPUT -p UDP -i ${WIRELESSIF_1}  --dport ${PROXY_PORT} -j ACCEPT


##ROUTER主機導向內網主機
#proxy
#iptables -t nat -A PREROUTING -i ${WIRELESSIF_1} -s {NETWORK_TEMPAP} -p tcp --dport 80 -j REDIRECT --to-port ${PROXY_PORT} 
#iptables -t nat -A PREROUTING -i ${INIF} -s {NETWORK_TEMPAP} -p tcp --dport 80 -j REDIRECT --to-port ${PROXY_PORT}


#minetestserver
iptables -t nat -A PREROUTING  -p tcp --dport ${MINETESTSERVER_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MINETESTSERVER_PORT}
iptables -t nat -A PREROUTING  -p udp --dport ${MINETESTSERVER_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MINETESTSERVER_PORT}

#http server
iptables -t nat -A PREROUTING  -p tcp --dport 80 -j DNAT --to-destination ${MINETESTSERVER_IP}:80
iptables -t nat -A PREROUTING  -p udp --dport 80 -j DNAT --to-destination ${MINETESTSERVER_IP}:80


#/sbin/iptables -t nat -A PREROUTING  -i lo -p tcp --dport 80 -j REDIRECT --to-port 3128
#/sbin/iptables -t nat -A PREROUTING  -i lo -p udp --dport 80 -j REDIRECT --to-port 3128

#iptables -t nat -A PREROUTING -i $INIF  -p tcp --dport 80 -j REDIRECT --to-port 3128 
#iptables -t nat -A PREROUTING -i $INIF  -p tcp --dport 443 -j REDIRECT --to-port 3128

#允許成為NAT
#/sbin/iptables -t nat -A POSTROUTING -s ${IP_LOCAL} -o $EXTIF -j MASQUERADE
/sbin/iptables -t nat -A POSTROUTING -s ${IP_TEMPAP} -o $EXTIF -j MASQUERADE

echo "[DONE...]"


