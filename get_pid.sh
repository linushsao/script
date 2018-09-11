#!/bin/bash
#

if [ $1 == "" ]; then
exit 0 
fi

processId=$(ps -ef | grep $1 | grep -v 'grep' | awk '{ printf $2 }')
echo $processId
