
D=`date +%F@%R`

cd /home/linus/Downloads

CHECK=`cat /proc/meminfo | grep "SwapTotal:             0 kB"`

if [ "$CHECK" != "" ]; then
swapon /dev/sda8
echo $D" restart swapfile..." > check_swap.log
else
echo $D" Already have swapfile..." > check_swap.log
fi

