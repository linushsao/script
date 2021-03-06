#!/bin/bash


#exit 0

PARAM="hostapd"
CHECK=""
PATH_LOG="/home/linus/log"


#NETHOURS=(22 23 0 1 2 3 4 5 6 7 12 13 18 19)
NETHOURS=(`cat /home/linus/log/NETHOURS_1.conf`)

#get today's data
DTIME=`date +%F@%R`
NOW=`date +%u`
HOUR=`date +%H`
MIN=`date +%M`

#starting to check time
for ((i=0; i<${#NETHOURS[@]}; i++))
do 
		D1=${NETHOURS[$i]} 
		if [ `expr "$D1" - "$HOUR"` == "0" ]; then
			CHECK="TRUE"
			c1=`pidof ${PARAM}`
			echo $c1
			if [ "$c1" == "" ];then
			/home/linus/script/nat-family-1.sh `cat ${PATH_LOG}/check_ap_param`
			echo "TURN ON Ap..."
			echo "$DTIME :turn on HOSTAPD" >> /home/linus/log/check_ap.log
			else
			echo "$DTIME :HOSTAPD is ALIVE" >> /home/linus/log/check_ap.log
			fi
		fi
done

if [ "$CHECK" == "" ];then
	killall hostapd
	echo "TURN OFF HOSTAPD"
	echo "$DTIME :turn off HOSTAPD" >> /home/linus/log/check_ap.log
	echo "" > ${PATH_LOG}/AP_ID
fi
echo "CHECK:"$CHECK
exit 0
#if [ "$c1" == "" ];then
#/home/linus/script/run-nat-filter-reset-1.sh
#fi


