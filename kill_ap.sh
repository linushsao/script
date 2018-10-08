#!/bin/bash

#exit 0

	object=$1
	filter=" "
	until [ "${filter}" == "" ]  
  		do
    		filter=`pidof ${object}`
    		kill ${filter} ;sleep 1
	done

	/home/linus/script/my_log.sh " ES_ENGLISH:terminated..."

