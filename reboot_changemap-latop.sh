#!/bin/bash

#exit 0
HOME_MODE=""

for var in "$@"
do
    #echo "$var"
    if [ "$var" == "--stop-homeserver" ]
		then
		echo "[STOP HOMESERVER]..."
		HOME_MODE=""
	elif [ "$var" == "--start-homeserver" ]
		then
		echo "[START HOMESERVER]..."
		HOME_MODE="TRUE"
	fi

done

	if  [ "$HOME_MODE" == "TRUE" ]; then
		rm /home/linus/script/home-server-deny
		else
		touch /home/linus/script/home-server-deny
		killall minetestserver
	fi
	
