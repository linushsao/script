

INIF="wlp3s0"
OUTIF="wlx74da38b92029"
ESSID="Linuslab-AP"
PASSWD="0726072652"

killall hostapd; sleep 2
ifconfig $OUTIF up ; sleep 1
/home/linuslab/Downloads/src/create_ap/create_ap $OUTIF $INIF $ESSID $PASSWD
