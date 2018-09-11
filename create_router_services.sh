#!/bin/bash
#

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
