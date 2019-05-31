#!/bin/bash

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"

case $1 in
	"now")
	for i in `atq | awk '{print $1}'`;do atrm $i;done
	CHECK1="$2"
	killall es_english.sh
	${PATH_SCRIPT}/kill_ap.sh mplayer
	${PATH_SCRIPT}/create_public.sh
        ${PATH_SCRIPT}/my_pika-start.sh
	at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/clear_router.sh
        at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/my_random-passwd.sh
        at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/my_pkill.sh
	COUNT=`expr "${CHECK1}" - "10"`
	at now "+${COUNT}minutes" < ${PATH_SCRIPT}/my_pika-end.sh 

        COUNT=`expr "${CHECK1}" - "1"`
        at now "+${COUNT}minutes" < echo "" > ${PATH_LOG}/TIMER

	echo "ON" > ${PATH_LOG}/TIMER
	;;

       "osnow")
        touch ${PATH_LOG}/switch_AUSTIN	
        ;;

	"clock")
	for i in `atq | awk '{print $1}'`;do atrm $i;done
	CHECK1="$2"
        CHECK2="$3"
        killall es_english.sh
        ${PATH_SCRIPT}/kill_ap.sh mplayer
        at ${CHECK1} < ${PATH_SCRIPT}/my_pika-start.sh
        at ${CHECK1} < ${PATH_SCRIPT}/create_public.sh
        at ${CHECK2} < ${PATH_SCRIPT}/clear_router.sh	
        at ${CHECK2} < ${PATH_SCRIPT}/my_random-passwd.sh  
        at ${CHECK2} < ${PATH_SCRIPT}/my_pkill.sh

        COUNT=`expr "${CHECK2}" - "10"`
        at now +${COUNT}minutes < ${PATH_SCRIPT}/my_pika-end.sh

        COUNT=`expr "${CHECK2}" - "1"`
        at now +${COUNT}minutes < echo "" > ${PATH_LOG}/TIMER

	echo "ON" > ${PATH_LOG}/TIMER
	;;

       "suspend")
        for i in `atq | awk '{print $1}'`;do atrm $i;done
	${PATH_SCRIPT}/clear_router.sh
	${PATH_SCRIPT}/my_log.sh "Timer stop counting..."

	echo "" > ${PATH_LOG}/TIMER
        ;;

       "ossuspend")
        rm ${PATH_LOG}/switch_AUSTIN

	echo "" > ${PATH_LOG}/TIMER
	;;
	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP TIME_ALARM}"
	exit 0
	;;
esac

/home/linus/script/my_log.sh " ENABLE TIMER: $1 $2 $3 $4 "
