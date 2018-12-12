#!/bin/bash
#

NAME=`date +%A%H%M`
filter=" "

until [ "${filter}" == "" ]  
  do
    filter=`pidof minetestserver`
    kill ${filter} ;sleep 1
    echo $filter
done

echo "BACKUP" > /home/linus/log/if_backup
cd /home/linus/.minetest/worlds
tar zcvf /home/linus/Downloads/"worlds-"$NAME.tgz * 

#cd /var/www/html/mars/
#tar zcvf /home/linus/Downloads/"logs-"$NAME.tgz *

echo "" > /home/linus/log/if_backup

