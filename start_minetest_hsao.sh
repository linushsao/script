#!/bin/bash

#exit 0

world_folder="hsao"
game_folder="world_of_hsao"
game_id=""
port="30000"

#screen -t StableSERVER -d -m ~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.conf &

~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.conf &
