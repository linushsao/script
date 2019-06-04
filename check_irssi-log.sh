#!/bin/bash
#

#exit 0
YEAR=`date +%Y`
DATE=`date +%F`
MONTH=`date +%B`

mkdir -p /var/www/html/mars/log/$YEAR/$MONTH
echo "" >/var/www/html/mars/log/$YEAR/$MONTH/$DATE.html
echo "/var/www/html/mars/log/$YEAR/$MONTH/$DATE.html" 
exit 0
sed 's/</[/g' /home/linus/.irssi/irclogs/FREENODE/#marsserver.log > /tmp/output-a.txt
sed 's/>/]/g' /tmp/output-a.txt > /tmp/output1-a.txt

awk '{print $0, "<br>"}' /tmp/output1-a.txt > /var/www/html/mars/log/$YEAR/$MONTH/$DATE.html

