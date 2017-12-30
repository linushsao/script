#!/bin/bash

#exit 0

world_folder="marsu-1"
game_folder="marsu-1"
game_id="marsu-1"
port="30021"

rm /home/linus/.minetest/worlds/$world_folder/env_meta.txt

cd /home/linus/.minetest/games/$game_folder/
echo "" > ./minetest.announce.conf
cat ./minetest.conf >>    ./minetest.announce.conf
cat /home/linus/Downloads/announce/add_announce_$world_folder.txt >> ./minetest.announce.conf

#screen -t StableSERVER -d -m ~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf &

~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.announce.conf &
