#!/bin/bash

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
FLAG="ON"

case $1 in
	"now")
	for i in `atq | awk '{print $1}'`;do atrm $i;done
	CHECK1="$2"
	killall es_english.sh
	${PATH_SCRIPT}/kill_ap.sh mplayer
	${PATH_SCRIPT}/create_public.sh
        ${PATH_SCRIPT}/my_pika-start.sh
	${PATH_SCRIPT}/timer_launch.sh

	at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/clear_router.sh
        at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/my_random-passwd.sh
        at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/my_pkill.sh
	COUNT=`expr "${CHECK1}" - "10"`
	at now "+${COUNT}minutes" < ${PATH_SCRIPT}/my_pika-end.sh 

        COUNT=`expr "${CHECK1}" - "1"`
        at now "+${COUNT}minutes" < ${PATH_SCRIPT}/timer_erase.sh
	;;

       "osnow")
        touch ${PATH_LOG}/switch_AUSTIN	
        ;;

	"clock")
	for i in `atq | awk '{print $1}'`;do atrm $i;done
	START="$2"
        PERIOD="$3"
        killall es_english.sh
        ${PATH_SCRIPT}/kill_ap.sh mplayer

	#prepare script
        echo "${PATH_SCRIPT}/timer_erase.sh;sleep 1" > ${PATH_LOG}/temp.sh
        echo "${PATH_SCRIPT}/clear_router.sh" >> ${PATH_LOG}/temp.sh
	echo "${PATH_SCRIPT}/my_random-passwd.sh" >> ${PATH_LOG}/temp.sh
	echo "${PATH_SCRIPT}/my_pkill.sh" >> ${PATH_LOG}/temp.sh
	echo "at now +${PERIOD}minutes < ${PATH_LOG}/temp.sh" > ${PATH_LOG}/set_end.sh

        at ${START} < ${PATH_SCRIPT}/my_pika-start.sh
        at ${START} < ${PATH_SCRIPT}/create_public.sh
        at ${START} < ${PATH_LOG}/set_end.sh
        at ${START} < ${PATH_SCRIPT}/timer_launch.sh

        #at ${CHECK2} < ${PATH_SCRIPT}/clear_router.sh	
        #at ${CHECK2} < ${PATH_SCRIPT}/my_random-passwd.sh  
        #at ${CHECK2} < ${PATH_SCRIPT}/my_pkill.sh
	#echo "ON" > ${PATH_LOG}/TIMER
	;;

       "suspend")
        for i in `atq | awk '{print $1}'`;do atrm $i;done
	${PATH_SCRIPT}/timer_erase.sh;sleep 1
	${PATH_SCRIPT}/clear_router.sh
	${PATH_SCRIPT}/my_log.sh "Timer stop counting..."

        ;;

       "check_flag")
	#check if timer is on
        if [ -f /home/linus/log/TIMER ]; then
                echo "TIMER is on,can't disable network"
		else
		echo "TIMER is off,can disable network"
        fi

        ;;

       "ossuspend")
        rm ${PATH_LOG}/switch_AUSTIN

	${PATH_SCRIPT}/timer_erase.sh
	;;
	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP TIME_ALARM}"
	exit 0
	;;
esac

/home/linus/script/my_log.sh "[TIMER Configure] $1 $2 $3 $4 "
