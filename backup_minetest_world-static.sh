
NAME="marsu-static"
#echo $NAME

#mkdir -p  /home/linus/.minetest/worlds/$NAME
#cp -rf /home/linus/.minetest/worlds/marsu/* /home/linus/.minetest/worlds/$NAME

cd /home/linus/.minetest/worlds
tar zcvf /home/linus/Downloads/"worlds-"$NAME.tgz *
