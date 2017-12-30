#!/bin/bash

DTIME=`date +%F@%R`

/home/linus/script/nat-add-nc.sh WEEK 121

echo "$DTIME" ": ADD 120NC to AUSTIN&ROSE. " >> /home/linus/script/net-filter.log
