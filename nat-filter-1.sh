#!/bin/bash

#BASIC CONFIGURE
FILTER_ROSE="--block-rose" 
FILTER_AUSTIN="--block-austin"
FILTER_MODE="TRUE" #TRUE mean BLOCK AUSTIN & ROSE
#FILTER_TC="--enable-tc"
FILTER_TC=""
FILTER_NETWORK=""
GAME_SWITCH="TRUE" #TRUE means opennet from minetest
TEST_MODE="TRUE"
RESET_MODE="--enable-reset"
HARDRESET_MODE=""
FORCE_MODE=""
AP_NAME="Linuslab-AP"
HOSTAP_PARAM="hostapd"
SCRIPT_NAME="[nat-filter]"

PATH_LOG="/home/linus/log"

#time sheet,children could use adsl-net during these time(0~24).
#day hour minute-start minute-end
NETHOURS=(
`cat ${PATH_LOG}/NETHOURS.conf`
)
#for summer vocation
NETHOURS_EXTRA=`cat ${PATH_LOG}/NETHOURS_EXTRA`

#NET_NOLIMITED,for kid to search books or others
NETHOURS_NOLIMITED=(
1 9 0 59
1 10 0 59
1 11 0 30
2 9 0 59
2 10 0 59
2 11 0 30
3 9 0 59
3 10 0 59
3 11 0 30
4 9 0 59
4 10 0 59
4 11 0 30
5 9 0 59
5 10 0 59
5 11 0 30
6 9 0 59
6 10 0 59
6 11 0 30
7 9 0 59
7 10 0 59
7 11 0 30
)

#time sheet,time limited per day. regulat time x 1.5
#day minutes

#TIME_LIMITED_SHEET=(
#1 45
#2 45
#3 45
#4 45
#5 45
#6 180
#7 180)
TIME_LIMITED_SHEET=(
`cat ${PATH_LOG}/TIME_LIMITED_SHEET.conf`
)

#get today's data
DTIME=`date +%F@%R`
NOW=`date +%u`
HOUR=`date +%H`
MIN=`date +%M`

echo ""
echo "++++++++++++++++++++++++++++++++[FILTER START]"
echo ""


#check param
echo "[CHECKING PARAM]..."
for var in "$@"
do
    #echo "$var"
    if [ "$var" == "--disable-test" ]
		then
		echo "[configure:DISABLE_TEST]"
		TEST_MODE=""
		elif [ "$var" == "--enable-gameswitch" ]
		then
		echo "[configure:ENABLE_GAMESWITCH]"
		GAME_SWITCH="TRUE"
		elif [ "$var" == "--enable-reset" ]
		then
		echo "[configure:ENABLE_reset]"
		RESET_MODE="--enable-reset"
		elif [ "$var" == "--enable-hardreset" ]
		then
		echo "[configure:ENABLE_HARDreset]"
		HARDRESET_MODE="--enable-hardreset"
		elif [ "$var" == "--enable-force" ]
		then 
		echo "[configure:ENABLE_force]"
		FORCE_MODE="--enable-force"
		elif [ "$var" == "--enable-extra" ]
		then
		echo "[configure:ENABLE_EXTRA]"
		EXTRA_MODE="TRUE"
		else
		echo "Wrong param : " $var
		exit 0
	fi
done

#[ALL functions]
#-------------------------------------------------------------
#function to check if current time is online time.
check_nethours () {
	if [ "$D1" == "$NOW" ]; then
			if [ `expr "$D2" - "$HOUR"` == "0" ]; then
					for ((ii="$D3";ii<="$D4";ii++))
					do
						if [ `expr "$ii" - "$MIN"` == "0" ]; then
							echo "###MATCH###"
							FILTER_MODE=""
						fi
					done
			fi
	fi
}

check_ap () {

			c1=`pidof ${HOSTAP_PARAM}`
			echo $c1
			if [ "$c1" == "" ];then
			FILTER_NETWORK="--enable-hardreset --enable-reset "`cat ${PATH_LOG}/check_ap_param`
			echo "TURN ON Ap..."
			MSG="turn on HOSTAPD" 
			log_record
			/home/linus/script/nat-family-1.sh $FILTER_NETWORK
			FILTER_NETWORK=""
			else
			MSG="HOSTAPD is ALIVE"
			log_record
			fi
}

log_record () {

if [ "${MSG}" != "" ];then
	echo "${SCRIPT_NAME} ${DTIME} : ${MSG} " >> ${PATH_LOG}/check_ap.log
fi
}

#check_allow_service
check_servies () {
	a=""
#	if [ "$a" == "" ] && [ "$FILTER_MODE" == ""  ];then
#		echo "[START TINYPROXY]..."
#		systemctl start tinyproxy
#	elif [ "$a" != "" ] && [ "$FILTER_MODE" != ""  ];then
#		echo "[STOP TINYPROXY]..."
#		systemctl stop tinyproxy
#	fi

}
#function to check if time-limited.
check_time_limited () {
	if [ "$D1" == "$NOW" ]; then
		echo "###MATCH time limited###"
		extra_tl=`cat ${PATH_LOG}/EXTRA_TL`
		if [ "$extra_tl" == "" ];then
			extra_tl=0
		fi
		TODAY_LIMITED=`expr "$D2" + "$extra_tl"`
	fi
}
#-------------------------------------------------------------

#check if hostapd alive at first
check_ap

#starting to check time
COUNT=0
for ((i=0; i<${#NETHOURS[@]}; i++))
do 
	COUNT=`expr "$COUNT" + "1"`
	if [ "$COUNT" == "1" ]; then
		D1=${NETHOURS[$i]} 
	elif [ "$COUNT" == "2" ]; then
		D2=${NETHOURS[$i]} 
	elif [ "$COUNT" == "3" ]; then
		D3=${NETHOURS[$i]} 
	elif [ "$COUNT" == "4" ]; then
		D4=${NETHOURS[$i]} 
		COUNT=0
		check_nethours
		check_servies
	fi
done

COUNT=0
for ((i=0; i<${#NETHOURS_NOLIMITED[@]}; i++))
do 
	COUNT=`expr "$COUNT" + "1"`
	if [ "$COUNT" == "1" ]; then
		D1=${NETHOURS_NOLIMITED[$i]} 
	elif [ "$COUNT" == "2" ]; then
		D2=${NETHOURS_NOLIMITED[$i]} 
	elif [ "$COUNT" == "3" ]; then
		D3=${NETHOURS_NOLIMITED[$i]} 
	elif [ "$COUNT" == "4" ]; then
		D4=${NETHOURS_NOLIMITED[$i]} 
		COUNT=0
		check_servies
	fi
done


COUNT=0
for extra_time in $NETHOURS_EXTRA
	do
		COUNT=`expr "$COUNT" + "1"`
		if [ "$COUNT" == "1" ]; then
			D1=${extra_time} 
		elif [ "$COUNT" == "2" ]; then
			D2=${extra_time} 
		elif [ "$COUNT" == "3" ]; then
			D3=${extra_time} 
		elif [ "$COUNT" == "4" ]; then
			D4=${extra_time} 
			COUNT=0
			check_nethours
		fi
done


#check the time limited of today
COUNT=0
for ((i=0; i<${#TIME_LIMITED_SHEET[@]}; i++))
do 
	COUNT=`expr "$COUNT" + "1"`
	if [ "$COUNT" == "1" ]; then
		D1=${TIME_LIMITED_SHEET[$i]} 
	elif [ "$COUNT" == "2" ]; then
		D2=${TIME_LIMITED_SHEET[$i]} 
		COUNT=0
		check_time_limited
	fi
done


# ready to decreasing network time of austin or rose
	NAME="ROSE AUSTIN"
echo
	echo "[CHECKING if ROSE&AUSTIN have ONELINE TIME]..."
	#check if austin&rose have net time
	for name in $NAME
		do
		echo "[CHECKING if NC exist]..."
		if ! [ -f ${PATH_LOG}/nc_$name ]; then
			echo "0" > ${PATH_LOG}/nc_$name
		fi
		
		echo "[CHECKING if time limited file exist and compare]..."
		if ! [ -f ${PATH_LOG}/tl_$name ]; then
			echo "0" > ${PATH_LOG}/tl_$name
			else
			TL=`cat ${PATH_LOG}/tl_"$name"`
			if [ `expr "$TL" - "$TODAY_LIMITED"` == "0" ]; then
			FILTER_MODE="TRUE"
			echo "[CHECKING TimeLimited: $name already use $TL minutes]..."
			fi
		fi

		COIN=`cat ${PATH_LOG}/nc_"$name"`
	
		if [ "$COIN" != "0" ] && [ "$FILTER_MODE" != "TRUE" ]
			then
			if [ "$GAME_SWITCH" == "" ] || [ -f ${PATH_LOG}/switch_"$name" ]
			then
				OP="1"
				if ! [ -f ${PATH_LOG}/minetest_launch ]; then
					COUNT=`expr "$COIN" - "$OP"` #check evey 1 minute,decrease the nc
					COUNT1=`expr "$TL" + "$OP"` #check evey 1 minute,increase the time_limited.
				fi
				echo "$COUNT" > ${PATH_LOG}/nc_"$name"
				echo "$COUNT1" > ${PATH_LOG}/tl_"$name"
				if [ "$name" == "AUSTIN" ]; then
					FILTER_AUSTIN=""
					elif [ "$name" == "ROSE" ]; then
					FILTER_ROSE=""
				fi
			fi
		
		else
			if [ "$COIN" != "0" ]; then
				echo "[$name has no NC ...]"
			fi
			if [ "$FILTER_MODE" != "TRUE" ]; then
				echo "[$name was BLOCKED ...]"
			fi
			
			if [ "$COIN" == "0" ] && [ -f ${PATH_LOG}/switch_"$name" ]; then
				rm ${PATH_LOG}/switch_"$name" #automatically turn-off user's nc switch.
				MSG="${name} SWITCH OFF(by system) "
				log_record
			fi
				
		fi
		ls -al ${PATH_LOG}/ | grep $name
		echo "NC: "`cat ${PATH_LOG}/nc_$name`
		echo "TL/TOTAL: "`cat ${PATH_LOG}/tl_$name` "/ "$TODAY_LIMITED
		echo "TC: "`cat ${PATH_LOG}/tc_$name`

	done

EXTRA=`cat ${PATH_LOG}/extra_mode` #ignore time
if [ "$(echo -e "${EXTRA}" | tr -d '[:space:]')" != "" ]; then
	FILTER_MODE=""
	else
	echo "[DISABLE EXTRA_MODE ]..."
fi	

if [ "$FILTER_ROSE" != "" ] || [ "$FILTER_AUSTIN" != "" ]  #block AUSTIN&ROSE
then
	echo "[DISABLE TC MODE]..."
	FILTER_TC="" #if austin&rose could not be online,it's not necessary to enable tc
fi


if [ "$FILTER_MODE" != "" ];then
	FILTER_NETWORK="${FILTER_NETWORK} --enable-intranet"
	#killall hostapd
	echo "TURN OFF FORWARD TO INTERNET"
	MSG="turn off FORWARD to internet"
	log_record
	#echo "" > ${PATH_LOG}/AP_ID
fi


#ready to set command.

echo "[STARTING TO CONFIURE FILTER PARAM]..."
PARA=$FILTER_ROSE" "$FILTER_AUSTIN" "$FILTER_TC" "$FILTER_NETWORK

if [ "$FORCE_MODE" != "" ]; then
	echo "" > ${PATH_LOG}/para
	echo "[FORCE MODE,REASE OLD PARA file]..."
fi

if ! [ -f ${PATH_LOG}/para ]; then
    touch ${PATH_LOG}/para
	echo "[CREATE NEW EMPTY PARA file]..."
fi
OLD_PARA=`cat ${PATH_LOG}/para`

MSG="OLD_PARA: $OLD_PARA" ; log_record
MSG="NEW_PARA: $PARA" ; log_record

if [ "$TEST_MODE" == "TRUE" ]; then #only for test,not execute command

	echo "[TEST MODE | CURRENT PARA CONF AS FELLOWING]..."
	echo $PARA
	exit 0
elif [ "$(echo -e "${PARA}" | tr -d '[:space:]')" == "$(echo -e "${OLD_PARA}" | tr -d '[:space:]')" ]; then
	echo "NOT execute script,just show the same param: ${PARA}"
	MSG="DUPLUCATE PARAM = | ${PARA} |"
	log_record
	exit 0
	
else #start to execute command

	echo "[EXECUTE MODE ]..."
	PARA=${PARA}" --enable-reset"
	echo  $PARA > ${PATH_LOG}/para
	MSG="EXECUTE PARAM = | ${PARA} |"
	log_record
	
	/home/linus/script/nat-family-1.sh $PARA
fi

echo "++++++++++++++++++++++++++++++++[FILTER END]"

