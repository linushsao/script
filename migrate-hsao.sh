#!/bin/bash

#exit 0

world_folder="hsao"
game_folder="world_of_hsao"
game_id=""
port="30000"


~/Downloads/src/minetest_latest/bin/minetestserver --worldname $world_folder --migrate leveldb
