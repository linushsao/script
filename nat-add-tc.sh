#!/bin/bash

#BASIC CONFIGURE

NAME="ROSE AUSTIN LINUS"
for name in $NAME
	do
	if ! [ -f /home/linus/log/tc_$name ]; then
    echo "0" > /home/linus/log/tc_$name
	fi
done

if [ "$1" == "ROSE" ]
	then
	COIN=`cat /home/linus/log/tc_ROSE`
	if [ "$COIN" == "" ];then
		COIN=0
	fi
	ADD_COIN=`awk "BEGIN {print "$2" + "$COIN" }"`
	echo $ADD_COIN > /home/linus/log/tc_ROSE
	elif [ "$1" == "AUSTIN" ]
		then
		COIN=`cat /home/linus/log/tc_AUSTIN`
		if [ "$COIN" == "" ];then
			COIN=0
		fi
	ADD_COIN=`awk "BEGIN {print "$2" + "$COIN" }"`
		echo $ADD_COIN > /home/linus/log/tc_AUSTIN
	elif [ "$1" == "LINUS" ]
		then
		COIN=`cat /home/linus/log/tc_LINUS`
		if [ "$COIN" == "" ];then
			COIN=0
		fi
	ADD_COIN=`awk "BEGIN {print "$2" + "$COIN" }"`
		echo $ADD_COIN > /home/linus/log/tc_LINUS
	elif [ "$1" == "WEEK" ] #add weektime to austin&rose
		then
			COIN=`cat /home/linus/log/tc_ROSE`
	ADD_COIN=`awk "BEGIN {print "$2" + "$COIN" }"`
			echo $ADD_COIN > /home/linus/log/tc_ROSE
			COIN=`cat /home/linus/log/tc_AUSTIN`
	ADD_COIN=`awk "BEGIN {print "$2" + "$COIN" }"`
			echo $ADD_COIN > /home/linus/log/tc_AUSTIN
fi
