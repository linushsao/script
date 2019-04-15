#!/bin/bash
#

CHECK = `ps -aux | grep minetest | grep marsu`

if [ "${CHECK}" == "" ]; then
        /home/linus/script/my_log.sh "MARSU server is needed to be checked!!!"
        exit 0
fi


NAME=`date -I`
filter=" "

until [ "${filter}" == "" ]  
  do
    filter=`pidof minetestserver`
    kill ${filter} ;sleep 5 
    echo $filter
done

echo "BACKUP" > /home/linus/log/if_backup
cd /home/linus/.minetest/worlds
tar zcvf /home/linus/Downloads/"worlds-"$NAME.tgz * 
/home/linus/script/my_log.sh "Daily Backup for MARSU server... "

#cd /var/www/html/mars/
#tar zcvf /home/linus/Downloads/"logs-"$NAME.tgz *

echo "" > /home/linus/log/if_backup

