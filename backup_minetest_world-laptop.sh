exit 0

NAME=`date +%A%H%M`
#echo $NAME

cd /home/linus/.minetest/worlds
tar zcvf /home/linus/Downloads/"worlds".tgz * 

