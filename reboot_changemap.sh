#!/bin/bash

#exit 0

D=`date +%F`
IRC_LOG="#marsserver.log"

cd /home/linus/log
mkdir -p ./backup/$D
mv *.log /home/linus/log/backup/$D/

cd /home/linus/.minetest/worlds/marsu
mv griefer_file griefer_file-D$

#/home/linus/script/changemap.sh

killall -INT screen
killall -INT irssi
killall -INT minetestserver

cd /home/linus/irclogs/Freenode/
mv ./$IRC_LOG ./server.log
tar zcvf ./log_$D.tgz ./server.log

#check for extra action about mod.
#c1=`cat /home/linus/.minetest/worlds/marsu/flag_WorldEdit | grep "yes"`

#cd /home/linus/.minetest/games/marsu/mods/

#if [ "$c1" != "" ];then
#	cp -rf ../tools_mods/WorldEdit .
	#echo "" > /home/linus/.minetest/worlds/marsu/flag_WorldEdit
#	echo " ENABLE WORLDEDIT & RESET..."
#	else
#	rm -rf ./WorldEdit
#	echo " DISENABLE WORLDEDIT..."

#fi

/home/linus/script/delete_oldplayer-mars.sh
