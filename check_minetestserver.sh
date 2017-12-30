#!/bin/bash


#exit 0

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

/home/linus/script/check_irssi.sh

if [ "$c6" == "" ];then
#oull from github
cd /home/linus/.minetest/games/marsu/
git reset --hard HEAD
git pull
cd ./mods
cp -rf ../server_side/* .
cp -rf /home/linus/.minetest/secret/* .

/home/linus/script/start_minetest_game.sh marsu restart

echo $D" restart MARS server..." >> check_minetest.log
else
echo $D" MARS server Already starting..." >> check_minetest.log

sleep 15
a=`pidof minetestserver`
echo $a
renice -10 $a

fi
