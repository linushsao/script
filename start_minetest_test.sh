#!/bin/bash
#

#exit 0

clear

params1="test"

cd ~/script/tmp
ps -aux | grep $params1 | grep worldname > data.txt
cat data.txt | tr -s ' ' > data1.txt
result=`cut -d ' ' -f 2 data1.txt `
echo $result
kill -9 $result

world_folder="test"
game_folder=""
game_id="test"
port="30021"

~/Downloads/src/minetest_0.4.14/bin/minetestserver --worldname $world_folder --port $port --logfile /home/linus/log/$world_folder.log --config /home/linus/.minetest/minetest-test.conf  &
