#!/bin/bash

#exit 0

LOGGER="/home/linus/script/my_log.sh"

c1=`pidof irssi`
#echo $c1
if [ "$c1" == "" ];then
screen -t IRSSI -d -m irssi & 
fi


