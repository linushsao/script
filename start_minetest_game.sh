#!/bin/bash

#exit 0

HOST=`hostname`

if [ "$HOST" == "Debian-vio" ]; then
	MINETEST_SERVER=" minetestserver"
	else
	MINETEST_SERVER="/home/linus/Downloads/src/minetest_latest/bin/minetestserver"
fi

if ! [ -d /home/linus/.minetest/worlds/"$1" ]; then
	echo "world-folder $1 is not exist!!"
	exit 0
fi


kill_task () {
	screen -wipe
	params1="$1"
	cd ~/script/tmp
	ps -aux | grep $params1 | grep worldname > data.txt
	cat data.txt | tr -s ' ' > data1.txt
	result=`cut -d ' ' -f 2 data1.txt `
	echo $result
	kill  $result
}

launch_game () {
	rm /home/linus/.minetest/worlds/$world_folder/env_meta.txt
	rm /home/linus/.minetest/worlds/$world_folder/map.db/LOCK
	cd /home/linus/.minetest/games/$game_folder/
	echo "" > ./minetest.announce.conf
	cat ./minetest.conf >>    ./minetest.announce.conf
	if [ `hostname` == "$SERVER_NAME" ]; then
		cat /home/linus/Downloads/announce/add_announce_$world_folder.txt >> ./minetest.announce.conf
		cat /home/linus/Downloads/announce/add_irc_$world_folder.txt >> ./minetest.announce.conf
	fi

	#screen -t StableSERVER -d -m ~/Downloads/src/minetest_latest/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf & > /home/linus/log/launch_game.log

	$MINETEST_SERVER --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf > /home/linus/log/launch_game.log
}

check_param () {

	if [ "$2" == "restart" ]; then #restart game-server
		kill_task
		
		elif [ "$2" == "reset" ]
		then
		kill_task
		cd /home/linus/.minetest/worlds/"$1"
		mv world.mt ~/tmp
		rm -rf *
		mv ~/tmp/world.mt .
		
		elif [ "$2" == "kill" ]
		then
		kill_task

		exit 0
	fi
	
}

case ${1} in
  "marsu") #MarsSurvival
	world_folder="marsu"
	game_folder="marsu"
	game_id="marsu"
	port="30016"
	
	check_param
	launch_game
	;;

  "hsao") #World_of_hsao
	world_folder="hsao"
	game_folder="world_of_hsao"
	game_id=""
	port="30000"
	
	check_param
	launch_game
	;;

  "nc") #World_of_hsao
	world_folder="nc"
	game_folder="nc"
	game_id=""
	port="30001"
	
	check_param
	launch_game
	;;
	
  "lifeofsea") #World_of_hsao
	world_folder="lifeofsea"
	game_folder="LifeOfSea"
	game_id=""
	port="30014"
	
	check_param
	launch_game
	;;

  "monsterhunter") #World_of_hsao
	world_folder="monsterhunter"
	game_folder="MonsterHunter"
	game_id="MonsterHunter"
	port="30021"
	
	check_param
	launch_game
	;;
	
  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	echo "You MUST input parameters, ex> {${0} <marsu/hsao/lifeofsea> <restart/kill>}"
	;;
esac
