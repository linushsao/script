#!/bin/bash

#exit 0

world_folder="marsu"
game_folder="marsu"
game_id="marsu"
port="30016"

rm /home/linus/.minetest/worlds/$world_folder/env_meta.txt

cd /home/linus/.minetest/games/$game_folder/
echo "" > ./minetest.announce.conf
cat ./minetest.conf >>    ./minetest.announce.conf
cat /home/linus/Downloads/announce/add_announce_$world_folder.txt >> ./minetest.announce.conf
cat /home/linus/Downloads/announce/add_irc_$world_folder.txt >> ./minetest.announce.conf

#screen -t StableSERVER -d -m ~/Downloads/src/minetest_latest/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf &

~/Downloads/src/minetest_latest/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf &

