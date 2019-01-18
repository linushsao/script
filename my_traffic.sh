#!/bin/bash
#
EXTIF="enp2s0"
INIF="enx00e04b39d58c"
WIRELESSIF0="wlp3s0"
WIRELESSIF1="wlx74da38b92029"
PATH_LOG="/home/linus/log"
LOG_NAME="TCPDUMP"

D=`date +%F@%R`

tcpdump -w ${D}.pcap -i ${INIF} 2>${PATH_LOG}/${LOG_NAME}
