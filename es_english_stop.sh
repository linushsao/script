#!/bin/bash
#

NAME=`date +%A%H%M`
object="mplayer"
filter=" "

until [ "${filter}" == "" ]  
  do
    filter=`pidof ${object}`
    kill ${filter} ;sleep 1
    echo $filter
done

