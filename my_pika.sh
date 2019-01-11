#!/bin/bash

PATH_SOUND="/home/linus/sound"
case $1 in
	"start")
	mplayer ${PATH_SOUND}/pika-start.mp3
	;;
	"end")
        mplayer ${PATH_SOUND}/pika-end.mp3
	;;
	*)
	echo "wrong param{now TIME_PERIOD / clock TIME_START TIME_STOP}"
	exit 0
	;;
esac

