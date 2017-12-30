#!/bin/bash

#exit 0

world_folder="lifeofsea"
game_folder="LifeOfSea"
game_id=""
port="30014"

#screen -t StableSERVER -d -m ~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.conf &

~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/games/$game_folder/minetest.conf &
