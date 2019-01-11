#!/bin/bash

PATH_SCRIPT="/home/linus/script"

case $1 in
	"now")
	CHECK1="$2"
	${PATH_SCRIPT}/create_router.sh
	at now "+${CHECK1}minutes" < ${PATH_SCRIPT}/clear_router.sh
	COUNT=`expr "${CHECK1}" - "10"`
	at now "+${COUNT}minutes" < ${PATH_SCRIPT}/my_pika.sh end

	;;
	"clock")
	CHECK1="$2"
        CHECK2="$3"
        CHECK3="$4"
        at ${CHECK1} < ${PATH_SCRIPT}/my_pika-start.sh
        at ${CHECK1} < ${PATH_SCRIPT}/create_public.sh
        at ${CHECK2} < ${PATH_SCRIPT}/clear_router.sh	
        at ${CHECK3} < ${PATH_SCRIPT}/my_pika-end.sh 
	;;
	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP TIME_ALARM}"
	exit 0
	;;
esac

/home/linus/script/my_log.sh " ENABLE TIMER: $1 $2 $3 $4 "
