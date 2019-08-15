#!/bin/bash

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"
FLAG="ON"

case $1 in
	"on")
	touch ${PATH_LOG}/TIMER
	;;

       "off")
	rm ${PATH_LOG}/TIMER
        ;;

	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP TIME_ALARM}"
	exit 0
	;;
esac

