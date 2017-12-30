#!/bin/bash

#exit 0

ping -c1 www.yahoo.com.tw > ./output.txt
cat ./output.txt
c1=`cat ./output.txt | grep "Name or service not known"`
echo $c1

if [ "$c1" == "" ];then
echo "EMPTY"
fi

if [ "$c1" != "" ];then
echo "Bring up network..."
/home/linus/script/check_ap.sh
fi

c1=`pidof ntopng`
echo $c1
if [ "$c1" == "" ];then
ntopng &
fi
