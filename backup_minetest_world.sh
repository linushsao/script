
NAME=`date +%A%H%M`
#echo $NAME

cd /home/linus/.minetest/worlds
tar zcvf /home/linus/Downloads/"worlds-"$NAME.tgz * 

cd /var/www/html/mars/
tar zcvf /home/linus/Downloads/"logs-"$NAME.tgz *
