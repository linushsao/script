#looking for skyislands game's process pid and enable screen
#

params1='hsao'

cd ~/script/tmp
ps -aux | grep $params1 | grep root > data.txt
cat data.txt | tr -s ' ' > data1.txt
result=`cut -d ' ' -f 2 data1.txt `

screen -wipe > /dev/null
result_1=`screen -ls | grep $result | grep Detached`

if [ $result_1 != "" ];then
  screen -r $result
  exit 0
else
  screen -r -d $result
fi
