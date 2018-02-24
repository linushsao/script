#!/bin/bash
#

D=`date +%F@%R`

#BASIC CONFIGURE
RESET_MODE="" #TRUE:enable RESET,other:disable
HARD_RESET_MODE="" #TRUE:enable RESET,other:disable
WIRED_MODE="TRUE" #TRUE:enable wired,other:wireless
VERBOSE_MODE=""   #TRUE:enable debug mode
MOBILE_MODE="" #TRUE:enable mobile network
INTRANET_MODE="TRUE"  #TRUE means enable connect forward(NAT)
CREATE_AP="" #TRUE:enable create_ap app
BLOCK_TEST=""
TC_MODE="" # TRUE:tc enable traffic control,other:disable
CHECK_NETWORK=`cat home/linus/log/CHECK_NETWORK` # empty:disable
FORWARD="0"
SCRIPT_NAME="[nat-family]"

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
	elif [ "$var" == "--enable-intranet" ]
		then
		echo "[configure:ENABLE_INTRANET]"
		INTRANET_MODE=""
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

#-----------all function
log_record () {

	echo ${SCRIPT_NAME}" "${D}" :"${MSG} >> ${PATH_LOG}/check_ap.log

}
#-----------
sleep 1

if  [ "$HARD_RESET_MODE" == "TRUE" ]; then
	ifconfig ${INIF} up
	ifconfig ${EXTIF}  up
	ifconfig ${EXTIF_1}  up
	ifconfig $INIF 192.168.0.1 netmask 255.255.255.0
	MSG="network interface init..."
	log_record

	if  [ "$CREATE_AP" == "TRUE" ]; then
		#create softAP
		killall hostapd;sleep 1
		killall dhcpd;sleep 1
		create_ap $INIF $EXTIF Linuslab-AP 0726072652
		MSG="CREATE AP by CREATE_AP SCRIPT"
		log_record
	else
		systemctl stop haveged
		systemctl start haveged
		killall dhcpd;sleep 1
		dhcpd $INIF
		killall hostapd;sleep 1
		hostapd -dd /etc/hostapd/hostapd.conf
		MSG="CREATE AP by MANUEL(hostapd+dhcpd)"
		log_record
	fi

#connect to Yafinus
#killall wpa_supplicant
#sleep 1
#wpa_supplicant -i ${EXTIF_1} -D wext -c /home/linus/log/now.conf &
#sleep 1
#dhclient -v ${EXTIF_1} &

fi

if  [ "$INTRANET_MODE" == "" ]; then
	MSG="DISABLE IP_FORWARD MODE..."
	log_record
	FORWARD="0"
	else
	MSG="ENABLE IP_FORWARD MODE..."
	log_record
	FORWARD="1"
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
	echo ${FORWARD} > /proc/sys/net/ipv4/ip_forward
	
	MSG="RESET IPTABLES RULES & ENABLE IP_FORWARD"
	log_record
	
	if [ "$BLOCK_AUSTIN" == "TRUE" ]; then
		echo "[BLOCK AUSTIN]..."
		for ((i=0; i<${#IP_AUSTIN[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_AUSTIN[$i]}  -o $EXTIF -j DROP
			MSG="BLOCK AUSTIN"
			log_record
		done
	fi
		
	if [ "$BLOCK_ROSE" == "TRUE" ]; then
		echo "[BLOCK ROSE]..."
		for ((i=0; i<${#IP_ROSE[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_ROSE[$i]}  -o $EXTIF -j DROP
			MSG="BLOCK ROSE"
			log_record
		done
	fi
	if [ "$BLOCK_TEST" == "TRUE" ]; then
		echo "[BLOCK TESTING]..." ; sleep 1
		for ((i=0; i<${#IP_TEST[@]}; i++))
		do 
			$IPTABLES -A FORWARD -s ${IP_TEST[$i]}  -o $EXTIF -j DROP
			MSG="BLOCK TEST"
			log_record
		done
	fi
		$IPTABLES -t nat -A POSTROUTING -j MASQUERADE
fi
exit 0
