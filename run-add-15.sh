#!/bin/bash

DTIME=`date +%F@%R`

/home/linus/script/nat-add-nc.sh WEEK 16

echo "$DTIME" ": ADD 15NC to AUSTIN&ROSE. " >> /home/linus/script/net-filter.log

