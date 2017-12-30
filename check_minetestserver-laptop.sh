#!/bin/bash

 #       exit 0

D=`date +%F@%R`

cd /home/linus/log

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

NETHOURS=(22 23 0 1 2 3 4 5 6 7 12 13 18 19)
#get today's data
DTIME=`date +%F@%R`
NOW=`date +%u`
HOUR=`date +%H`
MIN=`date +%M`

#starting to check time
for ((i=0; i<${#NETHOURS[@]}; i++))
do 
		D1=${NETHOURS[$i]} 
		if [ `expr "$D1" - "$HOUR"` == "0" ]; then
			start_minetest_game.sh nc kill
			start_minetest_game.sh hsao kill
			#echo "terminate minetestserver"
			exit 0 
		fi
done




if [ "$c1" == "" ];then
  /home/linus/script/start_minetest_game.sh hsao restart

  echo $D" restart HSAO server..." >> check_minetest.log
  else
  echo $D" HSAO server Already starting..." >> check_minetest.log

fi

if [ "$c2" == "" ];then
  /home/linus/script/start_minetest_game.sh nc restart

  echo $D" restart nc server..." >> check_minetest.log
  else
  echo $D" nc server Already starting..." >> check_minetest.log

fi

if [ "$c4" == "" ];then
  /home/linus/script/start_minetest_game.sh lifeofsea restart

  echo $D" restart SEA server..." >> check_minetest.log
  else
  echo $D" SEA server Already starting..." >> check_minetest.log

fi
