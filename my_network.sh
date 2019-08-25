#!/bin/bash

PATH_SCRIPT="/home/linus/script"
PATH_CONF="/home/linus/conf"

EXTIF=`cat ${CONF_DIR}/EXTIF`
INIF=`cat ${CONF_DIR}/INIF`
WIRELESSIF=`cat ${CONF_DIR}/WIRELESSIF`
WIRELESSIF_1=`cat ${CONF_DIR}/WIRELESSIF_1`

MY_ID="MY_NETWORK"

case $1 in
	"adsl")
	IP=$2
	GATEWAY=$3
	ifconfig ${EXTIF} ${IP} netmask 255.255.255.0
	route add default gw ${GATEWAY}

	${PATH_SCRIPT}/my_log.sh "[${MY_ID}] $1 ${IP} ${GATEWAY} ...

	;;
	"ap")
	PASSWD=`date +%Y%m%d`
	WIRELESSIF=$2
	ESSID=$3

	${PATH_SCRIPT}/my_log.sh "[${MY_ID}] $1 ${ESSID} ${PASSWD} ..."

	${PATH_SCRIPT}/kill_ap.sh hostapd
	create_ap ${WIRELESSIF} ${EXTIF} ${ESSID} ${PASSWD} &

	;;
        "wireless")

	${PATH_SCRIPT}/kill_ap.sh  wpa_supplicant

        ESSID=$2
	PASSWD=$3

	${PATH_SCRIPT}/my_log.sh "[${MY_ID}] $1 ${ESSID} ${PASSWD} ..."

	wpa_passphrase $ESSID $PASSWD > ${PATH_CONF}/wpa.conf
       	ifconfig ${WIRELESSIF} up ;sleep 1
       	wpa_supplicant -c ${PATH_CONF}/wpa.conf -i ${WIRELESSIF} -D nl80211 &
       	sleep 5 
       	dhclient ${WIRELESSIF} &

        ;;
	*)
	echo "wrong alarm param[adsl|ap|wireless]"
	echo "adsl IP GATEWAY"
        echo "ap   WLAN ESSID "
	echo "wireless ESSID PASSWD"
	exit 0
	;;
esac

