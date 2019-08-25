#!/bin/bash

#exit 0

#BASIC CONFIGURE
MOD_AP="" #not disable ap
MOD_TEMPAP="" #not disable temp_ap
MOD_ROUTER="" #disable only router mod

CONF_DIR="/home/linus/conf"

EXTIF=`cat ${CONF_DIR}/EXTIF`
INIF=`cat ${CONF_DIR}/INIF`
WIRELESSIF=`cat ${CONF_DIR}/WIRELESSIF`
WIRELESSIF_1=`cat ${CONF_DIR}/WIRELESSIF_1`

MINETESTSERVER_IP="192.168.0.10"
MARS_PORT="30016"
MY_WORLD_PORT="30000"

AP_IP="192.168.0.10"
MINECRAFTSERVER_PORT="25565"

NETWORK_TEMPAP="192.168.12.1/24"
NETWORK_AP="192.168.0.1/24" 
#

#check param
echo "[CHECKING PARAM]..."
for var in "$@"
do
    #echo "$var"
    if [ "$var" == "--disable-ap" ]
                then
                MOD_AP="TRUE"
                elif [ "$var" == "--disable-tempap" ]
                then
                MOD_TEMPAP="TRUE"
                elif [ "$var" == "--disable-firewall" ]
                then
                MOD_ROUTER="TRUE"
                else
                echo "Wrong param : " $var
                exit 0
        fi
done

echo "[ENABLE HAVEGED...]"
systemctl stop haveged 
systemctl start haveged  

ifconfig $INIF down   ;sleep 1
ifconfig $INIF up     ;sleep 1
ifconfig $INIF 192.168.0.1 netmask 255.255.255.0 ; sleep 1


# 1. 先載入一些有用的模組
modules="ip_tables iptable_nat ip_nat_ftp ip_nat_irc ip_conntrack 
	 ip_conntrack_ftp ip_conntrack_irc"
for mod in $modules
do
      testmod=`lsmod | grep "^${mod} " | awk '{print $1}'`
      if [ "$testmod" == "" ]; then
            modprobe $mod
      fi
done

/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -F -t nat
/sbin/iptables -X -t nat
/sbin/iptables -Z -t nat
/sbin/iptables -P INPUT   ACCEPT
/sbin/iptables -P OUTPUT  ACCEPT
/sbin/iptables -P FORWARD ACCEPT 
/sbin/iptables -t nat -P PREROUTING  ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT
/sbin/iptables -t nat -P OUTPUT      ACCEPT

#允許本機往外連線
/sbin/iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i $INIF -j ACCEPT
iptables -A INPUT -i $WIRELESSIF -j ACCEPT
iptables -A INPUT -i $WIRELESSIF_1 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT


# 1. 先設定好核心的網路功能：
  echo "1" > /proc/sys/net/ipv4/tcp_syncookies
  echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
  for i in /proc/sys/net/ipv4/conf/*/{rp_filter,log_martians}; do
        echo "1" > $i
  done
  for i in /proc/sys/net/ipv4/conf/*/{accept_source_route,accept_redirects,\
	send_redirects}; do
        echo "0" > $i
  done

if [ "${MOD_ROUTER}" == "" ]; then

# 3. 啟動額外的防火牆 script 模組
  if [ -f ${CONF_DIR}/iptables.deny ]; then
        sh ${CONF_DIR}/iptables.deny
  fi
  if [ -f ${CONF_DIR}/iptables.allow ]; then
        sh ${CONF_DIR}/iptables.allow
  fi
  if [ -f ${CONF_DIR}/iptables.http ]; then
        sh ${CONF_DIR}/iptables.http
  fi

# 4. 允許某些類型的 ICMP 封包進入
  AICMP="0 3 3/4 4 11 12 14 16 18"
  for tyicmp in $AICMP
  do
    iptables -A INPUT -i $EXTIF -p icmp --icmp-type $tyicmp -j ACCEPT
  done



#允許服務進入
iptables -A INPUT -p TCP -i $EXTIF --dport 443 -j ACCEPT # SSH
iptables -A INPUT -p UDP -i $EXTIF --dport 443 -j ACCEPT
iptables -A INPUT -p TCP -i $INIF --dport 443 -j ACCEPT # SSH
iptables -A INPUT -p UDP -i $INIF --dport 443 -j ACCEPT


##[ROUTER主機導向內網主機]
#minetestserver
iptables -t nat -A PREROUTING  -p tcp --dport ${MARS_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MARS_PORT}
iptables -t nat -A PREROUTING  -p udp --dport ${MARS_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MARS_PORT}
iptables -t nat -A PREROUTING  -p tcp --dport ${MY_WORLD_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MY_WORLD_PORT}
iptables -t nat -A PREROUTING  -p udp --dport ${MY_WORLD_PORT} -j DNAT --to-destination ${MINETESTSERVER_IP}:${MY_WORLD_PORT}

#minecraft
iptables -t nat -A PREROUTING  -p tcp --dport ${MINECRAFTSERVER_PORT} -j DNAT --to-destination ${AP_IP}:${MINECRAFTSERVER_PORT}
iptables -t nat -A PREROUTING  -p udp --dport ${MINECRAFTSERVER_PORT} -j DNAT --to-destination ${AP_IP}:${MINECRAFTSERVER_PORT}


fi

#允許成為NAT

echo "1" > /proc/sys/net/ipv4/ip_forward

if [ "${MOD_TEMPAP}" == "" ]; then
	/sbin/iptables -t nat -A POSTROUTING -s $NETWORK_TEMPAP -o $EXTIF -j MASQUERADE
fi

if [ "${MOD_AP}" == "" ]; then
/sbin/iptables -t nat -A POSTROUTING -s $NETWORK_AP  -o $EXTIF -j MASQUERADE
else
echo "[DISABLE NETWORK....]"
fi

echo "[DONE...]"


