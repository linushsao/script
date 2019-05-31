#!/bin/bash

#BASIC CONFIGURE
FILTER_MODE="TRUE" #TRUE mean BLOCK AUSTIN & ROSE
FILTER_TC="--enable-tc"
GAME_SWITCH="TRUE" #TRUE means opennet from minetest
TEST_MODE="TRUE"
RESET_MODE="--enable-reset"
HARDRESET_MODE=""
FORCE_MODE=""

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"

#time sheet,children could use adsl-net during these time(0~24).
#day hour minute-start minute-end
NETHOURS=(
`cat /home/linus/log/NETHOURS`
)
#for summer vocation
NETHOURS_EXTRA=`cat /home/linus/log/NETHOURS_EXTRA`

#NET_NOLIMITED,for kid to search books or others
NETHOURS_NOLIMITED=(
`cat /home/linus/log/NETHOURS_NOLIMITED`
)

#time sheet,time limited per day. regulat time x 1.5
#day minutes

TIME_LIMITED_SHEET=(
`cat /home/linus/log/TIME_LIMITED_SHEET`
)

#get today's data
DTIME=`date +%F@%R`
NOW=`date +%u`
HOUR=`date +%H`
MIN=`date +%M`

NAME="austin rose linus"

echo ""
echo "++++++++++++++++++++++++++++++++[FILTER START]"
echo ""

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
		extra_tl=`cat /home/linus/log/EXTRA_TL`
		if [ "$extra_tl" == "" ];then
			extra_tl=0
		fi
		TODAY_LIMITED=`expr "$D2" + "$extra_tl"`
	fi
}
#-------------------------------------------------------------

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


#check if kid'd nettime should be bring up.
	for name in $NAME
	do
		if [ -f /home/linus/log/switch_${name} ]; then
			if ! [ -f /home/linus/log/bringup_$name ]; then
				echo "BRING UP NETWORK..."
#		       		${PATH_SCRIPT}/my_pika-start.sh
#		       		${PATH_SCRIPT}/create_public.sh
				touch /home/linus/log/bringup_$name
			fi
		fi	
	done	

# ready to decreasing network time of austin or rose

	echo "[CHECKING if ROSE&AUSTIN have ONELINE TIME]..."
	#check if austin&rose have net time
	for name in $NAME
		do
		echo "[CHECKING if NC exist]..."
		if ! [ -f /home/linus/log/nc_$name ]; then
			echo "0" > /home/linus/log/nc_$name
		fi
		
		echo "[CHECKING if time limited file exist and compare]..."
		if ! [ -f /home/linus/log/tl_$name ]; then
			echo "0" > /home/linus/log/tl_$name
			else
			TL=`cat /home/linus/log/tl_"$name"`
			if [ `expr "$TL" - "$TODAY_LIMITED"` == "0" ]; then
			FILTER_MODE="TRUE"
			echo "[CHECKING TimeLimited: $name already use $TL minutes]..."
			fi
		fi
		echo "FILTER_MODE: ${FILTER_MODE} ..."
		COIN=`cat /home/linus/log/nc_"$name"`
	
		#have nc & have tl,decreasing nc...
		if [ "$COIN" != "0" ] && [ "$FILTER_MODE" != "TRUE" ]
			then
			if [ -f /home/linus/log/switch_"$name" ]; then
				OP="1"
				COUNT=`expr "$COIN" - "$OP"` #check evey 1 minute,decrease the nc
				COUNT1=`expr "$TL" + "$OP"` #check evey 1 minute,increase the time_limited.
				echo "$COUNT" > /home/linus/log/nc_"$name"
				echo "$COUNT1" > /home/linus/log/tl_"$name"
			fi
		
		else
			if [ "$COIN" != "0" ]; then
				echo "[$name has no TL ...]"
			fi
			
			if [ "$COIN" == "0" ] && [ -f /home/linus/log/switch_"$name" ]; then
				rm /home/linus/log/switch_"$name" #automatically turn-off user's nc switch.
				echo "${DTIME} ${name} SWITCH OFF(by system) " >> /home/linus/log/switch.log
			fi
				
		fi

		ls -al ../log/ | grep $name
		echo "NC: "`cat ../log/nc_$name`
		echo "TL/TOTAL: "`cat ../log/tl_$name` "/ "$TODAY_LIMITED
		#echo "TC: "`cat ../log/tc_$name`

	done


