#!/bin/bash

#exit 0

	object=$1
	filter=" "

	until [ "${filter}" == "" ]  
  		do
    		filter=`pidof ${object}`
    		kill ${filter} ;sleep 1
    		echo $filter
	done

