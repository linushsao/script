#!/bin/bash
#exit 0
EXTIF="wlp3s0"
INIF="wlp0s29u1u3"
INIF_1="wlp0s20u2"

killall hostapd
killall dhcpd
ifconfig $EXTIF up
ifconfig $INIF up

	# 2. 清除規則、設定預設政策及開放 lo 與相關的設定值
	echo "[IPTABLES init]...";sleep 1
	
	PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin; export PATH
	iptables -F
	iptables -X
	iptables -Z
	iptables -P INPUT   ACCEPT
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

   modules="ip_tables iptable_nat ip_nat_ftp ip_nat_irc ip_conntrack ip_conntrack_ftp ip_conntrack_irc"
   for mod in $modules
   do
       testmod=`lsmod | grep "^${mod} " | awk '{print $1}'`
       if [ "$testmod" == "" ]; then
             modprobe $mod
       fi
   done


    echo "1" > /proc/sys/net/ipv4/ip_forward

	ifconfig $INIF up
	ifconfig $INIF_1  up
	#create_ap wlp0s29u1u3 wlp3s0 Linuslab-AP 0726072652
	create_ap $INIF $EXTIF Linuslab-AP 0726072652

        iptables -t nat -A POSTROUTING  -o $EXTIF -j MASQUERADE
	


    
    

    
    
               

  
  
