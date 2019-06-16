#!/bin/bash

NAME="kids austin rose"
NAME_APP="My_PKILL X"
PATH_SCRIPT="/home/linus/script"

   for name in $NAME
   do
	CHECK=`who | grep ${name}`
      	if [ ${name} != "" ]; then
		${PATH_SCRIPT}/my_random-passwd.sh
		pkill X	
		D=`date +%F@%R`
		${PATH_SCRIPT}/my_log.sh "[${NAME_APP}] pkill x / User: ${name}"

		exit 0
      	fi      
   done    

