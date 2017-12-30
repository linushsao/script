#!/bin/bash

#exit 0

c1=`pidof irssi`
#echo $c1
if [ "$c1" == "" ];then
screen -t IRSSI -d -m irssi & 
fi
