#!/bin/bash
#exit 0
D=`date +%F@%R`

#BASIC CONFIGURE
RESET_MODE="" #TRUE:enable RESET,other:disable
HARD_RESET_MODE="" #TRUE:enable RESET,other:disable
WIRED_MODE="TRUE" #TRUE:enable wired,other:wireless
VERBOSE_MODE=""   #TRUE:enable debug mode
MOBILE_MODE="" #TRUE:enable mobile network
CREATE_AP="" #TRUE:enable create_ap app
BLOCK_TEST=""
TC_MODE="" # TRUE:tc enable traffic control,other:disable
CHECK_NETWORK=`cat home/linus/log/CHECK_NETWORK` # empty:disable

PATH_LOG="/home/linus/log"

NETMASK="255.255.255.0"

#IP_AUSTIN="192.168.0.52"
#IP_AUSTIN_PHONE="192.168.0.60"
#IP_AUSTIN_PAD="192.168.0.54"
IP_AUSTIN_PC="192.168.0.51"
IP_AUSTIN=(
192.168.0.51
192.168.0.54
192.168.0.57
)

#IP_ROSE="192.168.0.5x"
#IP_ROSE_PHONE="192.168.0.58"
#IP_ROSE_PAD="192.168.0.59"
IP_ROSE_PC="192.168.1.55"
IP_ROSE=(
192.168.0.55
192.168.0.59
192.168.0.58
)

IP_TEST=(
192.168.0.56
)

IP_PUBLIC=(
192.168.12.134
)

MOBILES_AP=(`cat /home/linus/log/MOBILES.conf`)

#extra_ip of server of debian sources.list & others
#LIBRARY 163.29.36.96 203.64.154.21
IP_EXTRA=(
140.112.30.75
133.242.99.74
163.29.36.96
203.64.154.21
)

BLOCK_AUSTIN=""
BLOCK_ROSE=""
BLOCK_ALL=""
FILTER_MODE=""

#WIRED="enp2s0"
#WIRELESS1="wlp3s0"
EXTIF="wlp3s0"
EXTIF_1="wlp0s20u2"
INIF="wlp0s29u1u3"
INNET="192.168.0.0/24" # 若無內部網域介面，請填寫成 INNET=""

echo ""
echo "++++++++++++++++++++++++++++++++[INIT START]"

for var in "$@"
do
	echo "[CHECKING PARAM]..."
    if [ "$var" == "--enable-tc" ]
		then
		echo "[configure:ENABLE_TC]"
		TC_MODE="TRUE"
	elif [ "$var" == "--enable-verbose" ]
		then
		echo "[configure:ENABLE_VERBOSE]"
		VERBOSE_MODE="TRUE"
	elif [ "$var" == "--enable-create_ap" ]
		then
		echo "[configure:ENABLE_CREATE_AP]"
		CREATE_AP="TRUE"
	elif [ "$var" == "--enable-reset" ]
		then
		echo "[configure:ENABLE_reset]"
		RESET_MODE="TRUE"
	elif [ "$var" == "--enable-hardreset" ]
		then
		echo "[configure:ENABLE_hardreset]"
		HARD_RESET_MODE="TRUE"
	elif [ "$var" == "--enable-check-network" ]
		then
		echo "[configure:ENABLE_CHECK_NETWORK]"
		CHECK_NETWORK="TRUE"
	elif [ "$var" == "--block-austin" ]
		then
		echo "[configure:BLOCK_AUSTIN]"
		BLOCK_AUSTIN="TRUE"
	elif [ "$var" == "--block-rose" ]
		then
		echo "[configure:BLOCK_ROSE]"
		BLOCK_ROSE="TRUE"
	elif [ "$var" == "--enable-mobile" ]
		then
		echo "[configure:ENABLE MOBILE]"
		MOBILE_MODE="TRUE"
	elif [ "$var" == "--block-test" ]
		then
		echo "[configure:BLOCK_TEST]"
		BLOCK_TEST="TRUE"
	elif [ "$var" == "help" ]
		then
		echo "option: --enable-tc | --enable-reset | --disable-wired | --block-austin | --block-rose | --block-all"
		exit 0
	else
		echo "Wrong param : $var ,script is terminated!!"
		exit 0
	fi
	
done

if  [ "$HARD_RESET_MODE" == "TRUE" ]; then
ifconfig ${INIF} up
ifconfig ${EXTIF}  up
ifconfig ${EXTIF_1}  up

ifconfig $INIF 192.168.0.1

	if  [ "$CREATE_AP" == "TRUE" ]; then
		#create softAP
		#create_ap $INIF $EXTIF Linuslab-AP 0726072652
	else

		systemctl stop haveged
		systemctl start haveged
		killall dhcpd;sleep 1
		dhcpd $INIF
		killall hostapd;sleep 1
		hostapd -dd /etc/hostapd/hostapd.conf
	fi

#connect to Yafinus
#killall wpa_supplicant
#sleep 1
#wpa_supplicant -i ${EXTIF_1} -D wext -c /home/linus/log/now.conf &
#sleep 1
#dhclient -v ${EXTIF_1} &

fi

if  [ "$MOBILE_MODE" == "TRUE" ]; then
	ifconfig ${EXTIF_1}  up

	#starting to check mobile ap
	for ((i=0; i<${#MOBILES_AP[@]}; i++))
	do 
			D1=`iwlist ${EXTIF_1} scanning | grep ${NMOBILES_AP[$i]}`
			if [ "$D1" != "" && `cat ${PATH_LOG}/AP_ID` == "" ]; then
				echo "FOUND MOBILE AP :${NMOBILES_AP[$i] , trying to connecting to..."
				killall wpa_supplicant
				sleep 1
				wpa_supplicant -i ${EXTIF_1} -D wext -c /home/linus/log/${NMOBILES_AP[$i].conf &
				sleep 1
				dhclient -v ${EXTIF_1} &
				echo ${NMOBILES_AP[$i] > ${PATH_LOG}/AP_ID
				echo "$DTIME :FOUND MOBILE AP ${NMOBILES_AP[$i] , trying to connecting to..." >> /home/linus/log/mobile_ap.log
			fi
	done
fi


if  [ "$RESET_MODE" == "TRUE" ]; then

	IPTABLES=/sbin/iptables
	$IPTABLES -F
	$IPTABLES -F -t nat
	$IPTABLES -X

	$IPTABLES -P INPUT ACCEPT
	$IPTABLES -P OUTPUT ACCEPT
	$IPTABLES -P FORWARD ACCEPT

	modprobe ip_conntrack
	modprobe iptable_nat
	modprobe ip_conntrack_ftp
	modprobe ip_nat_ftp

	echo 1 > /proc/sys/net/ipv4/ip_forward
	
	if [ "$BLOCK_AUSTIN" == "TRUE" ]; then
		echo "[BLOCK AUSTIN]..."
		for ((i=0; i<${#IP_AUSTIN[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_AUSTIN[$i]}  -o $EXTIF -j DROP
			if [ "$VERBOSE_MODE" == "TRUE" ]; then
			echo "iptables -A FORWARD -s ${IP_AUSTIN[$i]}  -o $EXTIF -j DROP"
			fi		
		done
	fi
		
	if [ "$BLOCK_ROSE" == "TRUE" ]; then
		echo "[BLOCK ROSE]..."
		for ((i=0; i<${#IP_ROSE[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_ROSE[$i]}  -o $EXTIF -j DROP
			if [ "$VERBOSE_MODE" == "TRUE" ]; then
			echo "iptables -A FORWARD -s ${IP_ROSE[$i]}  -o $EXTIF -j DROP"
			fi		
		done
	fi

	if [ "$BLOCK_TEST" == "TRUE" ]; then
		echo "[BLOCK TESTING]..." ; sleep 1
		for ((i=0; i<${#IP_TEST[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_TEST[$i]}  -o $EXTIF -j DROP
			echo
		done
	fi

	echo "[ENABLE NAT]..." ;sleep 1
	$IPTABLES -t nat -A POSTROUTING -j MASQUERADE		

fi

#----TC/
if [ "$TC_MODE" == "TRUE" ];then #if doing traffic control
	echo "[ENABLE TC]..."

	# uploads
	# 設定上傳方面，先利用 iptables 給封包貼標籤，再交由 fw 過濾器進行過濾
 
	#iptables -t mangle -A PREROUTING -s 192.168.1.6 -m layer7 --l7proto dns -j MARK --set-mark 10
	#iptables -t mangle -A PREROUTING -s 192.168.1.6 -m layer7 --l7proto smtp -j MARK --set-mark 20
	#iptables -t mangle -A PREROUTING -s 192.168.1.6 -m layer7 --l7proto http -j MARK --set-mark 30

	iptables -t mangle -A PREROUTING -s $IP_AUSTIN_PC -j MARK --set-mark 40
	iptables -t mangle -A PREROUTING -s $IP_ROSE_PC   -j MARK --set-mark 50
	#	iptables -t mangle -A PREROUTING -s 192.168.1.2 -j MARK --set-mark 50
	#	iptables -t mangle -A PREROUTING -s 192.168.1.3 -j MARK --set-mark 60

	# downloads
	# 下載方面

	#iptables -t mangle -A POSTROUTING -d 192.168.1.6 -m layer7 --l7proto dns -j MARK --set-mark 10
	#iptables -t mangle -A POSTROUTING -d 192.168.1.6 -m layer7 --l7proto smtp -j MARK --set-mark 20
	#iptables -t mangle -A POSTROUTING -d 192.168.1.6 -m layer7 --l7proto http -j MARK --set-mark 30

	iptables -t mangle -A POSTROUTING -d $IP_AUSTIN_PC -j MARK --set-mark 40
	iptables -t mangle -A POSTROUTING -d $IP_ROSE_PC -j MARK --set-mark 50
	#	iptables -t mangle -A POSTROUTING -d 192.168.1.2 -j MARK --set-mark 50
	#	iptables -t mangle -A POSTROUTING -d 192.168.1.3 -j MARK --set-mark 60 

	# 清除 $EXTIF 所有佇列規則
	#tc qdisc del dev $EXTIF root 2>/dev/null

	# 定義最頂層(根)佇列規則，並指定 default 類別編號
	#tc qdisc add dev $EXTIF root handle 10: htb default 70

	# 定義第一層的 10:1 類別 (總頻寬)
	#tc class add dev $EXTIF parent 10:  classid 10:1 htb rate 384kbps ceil 384kbps

	# 定義第二層葉類別
	# rate 保證頻寬，ceil 最大頻寬，prio 優先權
	#tc class add dev $EXTIF parent 10:1 classid 10:10 htb rate 256kbps ceil 320kbps prio 2
	#tc class add dev $EXTIF parent 10:1 classid 10:20 htb rate 2kbps ceil 4kbps prio 2
	#tc class add dev $EXTIF parent 10:1 classid 10:30 htb rate 32kbps ceil 40kbps prio 3

	#tc class add dev $EXTIF parent 10:1 classid 10:40 htb rate 320kbps ceil 384kbps prio 0
	#tc class add dev $EXTIF parent 10:1 classid 10:50 htb rate 192kbps ceil 192kbps prio 1
	#tc class add dev $EXTIF parent 10:1 classid 10:60 htb rate 32kbps ceil 64kbps prio 1
	#tc class add dev $EXTIF parent 10:1 classid 10:70 htb rate 64kbps ceil 192kbps prio 1


	# 定義各葉類別的佇列規則
	# parent 類別編號，handle 葉類別佇列規則編號
	# 由於採用 fw 過濾器，所以此處使用 pfifo 的佇列規則即可
	#tc qdisc add dev $EXTIF parent 10:10 handle 101: pfifo
	#tc qdisc add dev $EXTIF parent 10:20 handle 102: pfifo
	#tc qdisc add dev $EXTIF parent 10:30 handle 103: pfifo
	#tc qdisc add dev $EXTIF parent 10:40 handle 104: pfifo
	#tc qdisc add dev $EXTIF parent 10:50 handle 105: pfifo
	#tc qdisc add dev $EXTIF parent 10:60 handle 106: pfifo
	#tc qdisc add dev $EXTIF parent 10:70 handle 107: pfifo

	# 設定過濾器
	# 指定貼有 10 標籤 (handle) 的封包，歸類到 10:10 類別，以此類推
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 10 fw classid 10:10
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 20 fw classid 10:20
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 30 fw classid 10:30
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 40 fw classid 10:40
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 50 fw classid 10:50
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 60 fw classid 10:60
	#tc filter add dev $EXTIF parent 10: protocol ip prio 100 handle 70 fw classid 10:70



	# QoS $INIF  下載方面
	#

	# 清除 $INIF所有佇列規則
	tc qdisc del dev $INIF root 2>/dev/null

	# 定義最頂層(根)佇列規則，並指定 default 類別編號
	tc qdisc add dev $INIF root handle 10: htb default 70

	# 定義第一層的 10:1 類別 (總頻寬)
	tc class add dev $INIF parent 10:  classid 10:1 htb rate 2048kbps ceil 2048kbps

	# 定義第二層葉類別
	# rate 保證頻寬，ceil 最大頻寬，prio 優先權
	#tc class add dev $INIF parent 10:1 classid 10:10 htb rate 1kbps ceil 1kbps prio 2
	#tc class add dev $INIF parent 10:1 classid 10:20 htb rate 2kbps ceil 32kbps prio 2
	#tc class add dev $INIF parent 10:1 classid 10:30 htb rate 32kbps ceil 212kbps prio 3

	tc class add dev $INIF parent 10:1 classid 10:40 htb rate 1024kbps ceil 2048kbps prio 0 
	tc class add dev $INIF parent 10:1 classid 10:50 htb rate 640kbps ceil 1024kbps prio 1
	#tc class add dev $INIF parent 10:1 classid 10:60 htb rate 640kbps ceil 640kbps prio 1
	tc class add dev $INIF parent 10:1 classid 10:70 htb rate 384kbps ceil 384kbps prio 1
	# 定義各葉類別的佇列規則
	# parent 類別編號，handle 葉類別佇列規則編號
	tc qdisc add dev $INIF parent 10:10 handle 101: pfifo
	tc qdisc add dev $INIF parent 10:20 handle 102: pfifo
	tc qdisc add dev $INIF parent 10:30 handle 103: pfifo
	tc qdisc add dev $INIF parent 10:40 handle 104: pfifo
	tc qdisc add dev $INIF parent 10:50 handle 105: pfifo
	tc qdisc add dev $INIF parent 10:60 handle 106: pfifo
	tc qdisc add dev $INIF parent 10:70 handle 107: pfifo

	# 設定過濾器
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 10 fw  classid 10:10
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 20 fw  classid 10:20
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 30 fw  classid 10:30
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 40 fw  classid 10:40
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 50 fw  classid 10:50
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 60 fw  classid 10:60
	tc filter add dev $INIF parent 10: protocol ip prio 100 handle 70 fw  classid 10:70	
	
	#----TC
fi

echo "++++++++++++++++++++++++++++++++[INIT END]"
echo ""
	


    
    

    
    
               

  
  
