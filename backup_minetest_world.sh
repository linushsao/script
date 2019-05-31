#!/bin/bash
#

CHECK=`ps -aux | grep minetest | grep marsu`
BACKUP_PATH="/home/linus/backup/marsu"

if [ "${CHECK}" == "" ]; then
        /home/linus/script/my_log.sh "MARSU server is needed to be checked!!!" marsu_backup.log
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
tar zcvf ${BACKUP_PATH}/worlds-${NAME}.tgz * 
/home/linus/script/my_log.sh "Daily Backup for MARSU server... "

echo "" > /home/linus/log/if_backup

