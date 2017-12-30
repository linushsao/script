#!/bin/bash

#BASIC CONFIGURE

NAME="ROSE AUSTIN LINUS"
for name in $NAME
	do
	if ! [ -f /home/linus/log/nc_$name ]; then
    echo "0" > /home/linus/log/nc_$name
	fi
done

if [ "$1" == "ROSE" ]
	then
	COIN=`cat /home/linus/log/nc_ROSE`
	if [ "$COIN" == "" ];then
		COIN=0
	fi
	ADD_COIN=`expr "$2" + "$COIN"`
	echo $ADD_COIN > /home/linus/log/nc_ROSE
elif [ "$1" == "AUSTIN" ]
	then
	COIN=`cat /home/linus/log/nc_AUSTIN`
	if [ "$COIN" == "" ];then
		COIN=0
	fi
	ADD_COIN=`expr "$2" + "$COIN"`
	echo $ADD_COIN > /home/linus/log/nc_AUSTIN
elif [ "$1" == "LINUS" ]
	then
	COIN=`cat /home/linus/log/nc_LINUS`
	if [ "$COIN" == "" ];then
		COIN=0
	fi
	ADD_COIN=`expr "$2" + "$COIN"`
	echo $ADD_COIN > /home/linus/log/nc_LINUS
elif [ "$1" == "WEEK" ] #add weektime to austin&rose
	then
		COIN=`cat /home/linus/log/nc_ROSE`
		ADD_COIN=`expr "$2" + "$COIN"`
		echo $ADD_COIN > /home/linus/log/nc_ROSE
		COIN=`cat /home/linus/log/nc_AUSTIN`
		ADD_COIN=`expr "$2" + "$COIN"`
		echo $ADD_COIN > /home/linus/log/nc_AUSTIN
elif [ "$1" == "RESET" ] #reset weektime to austin&rose
	then
		echo "0" > /home/linus/log/nc_ROSE
		echo "0" > /home/linus/log/nc_AUSTIN
		echo "0" > /home/linus/log/tl_ROSE
		echo "0" > /home/linus/log/tl_AUSTIN
		echo "" > /home/linus/log/extra_mode
		echo "0" > /home/linus/log/EXTRA_TL
		echo "" > /home/linus/log/para
		rm /home/linus/log/switch_ROSE
		rm /home/linus/log/switch_AUSTIN
		rm /home/linus/log/mark_ROSE
		rm /home/linus/log/mark_AUSTIN
		echo "" > /home/linus/log/NETHOURS_EXTRA
fi
