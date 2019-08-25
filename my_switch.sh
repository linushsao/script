#!/bin/bash

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
FLAG="ON"

case $1 in
	"on")
	touch ${PATH_LOG}/TIMER
	;;

       "off")
	mv  ${PATH_LOG}/TIMER ${PATH_LOG}/TIMER_OFF
        ;;

	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP TIME_ALARM}"
	exit 0
	;;
esac

