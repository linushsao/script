#!/bin/bash

PATH_SOUND="/home/linus/sound"
case $1 in
	"pika-start")
	mplayer ${PATH_SOUND}/pika-start.mp3
	;;
	"pika-end")
        mplayer ${PATH_SOUND}/pika-end.mp3
	;;
	*)
	echo "wrong alarm param{pika-start / pika-end }"
	exit 0
	;;
esac

