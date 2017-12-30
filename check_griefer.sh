#!/bin/bash

#exit 0
YEAR=`date +%Y`
DATE=`date +%F`
MONTH=`date +%B`

#echo $YEAR
#echo $DATE

mkdir -p /var/www/html/mars/griefer/$YEAR/$MONTH

cd /home/linus/.minetest/worlds/marsu
cp -rf griefer_file /var/www/html/mars/griefer/$YEAR/$MONTH/$DATE.html


sed 's/</[/g' /home/linus/log/marsu.log > /tmp/output.txt
sed 's/>/]/g' /tmp/output.txt > /tmp/output1.txt
awk '{print $0, "<br>"}' /tmp/output1.txt > /tmp/$DATE-serverlog.html
cd /var/www/html/mars/griefer/$YEAR/$MONTH
tar zcvf ./$DATE-serverlog.tgz /tmp/$DATE-serverlog.html
