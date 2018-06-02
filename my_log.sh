#!/bin/bash

D=`date +%F@%R`
PATH_LOG="/home/linus/.pass"

echo $D" "$1 >> $PATH_LOG 
