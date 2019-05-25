#!/bin/bash

#exit 0

CHECK=`cat /home/linus/log/if_backup`
echo $CHECK
if [ "$CHECK" == "BACKUP" ];then
exit 0
fi

D=`date +%F@%R`

cd /home/linus/.minetest

c1=`netstat -an | grep "0.0.0.0:30000"`
echo $c1
c2=`netstat -an | grep "0.0.0.0:30001"`
echo $c2
c3=`netstat -an | grep "0.0.0.0:30010"`
echo $c3
c4=`netstat -an | grep "0.0.0.0:30014"`
echo $c4
c5=`netstat -an | grep "0.0.0.0:30012"`
echo $c5
c6=`netstat -an | grep "0.0.0.0:30016"`
echo $c6
c21=`netstat -an | grep "0.0.0.0:30021"`
echo $c21

if [ "$c6" == "" ];then
cd /home/linus/.minetest/games/marsu/
git reset --hard HEAD
git pull
cd ./mods
cp -rf ../server_side/* .
cp -rf /home/linus/.minetest/secret/* .

/home/linus/script/start_minetest_game.sh marsu restart

/home/linus/script/my_log.sh " restart MARS server..." 

fi

if [ "$c1" == "" ];then

#/home/linus/script/start_minetest_game.sh hsao restart
#/home/linus/script/my_log.sh  " restart HSAO server..." 

fi

exit 0
