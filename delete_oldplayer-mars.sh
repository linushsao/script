#!/bin/bash
#

#exit 0

clear

params1="marsu"

cd ~/script/tmp

cd /home/linus/.minetest/worlds/$params1/players
#delete player's data who doesnt login more than 3 months
find ./* -mtime +90 -type f -delete
