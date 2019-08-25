#!/bin/bash

#exit 0
MY_ID="CLEAR ROUTER"

PATH_SCRIPT="/home/linus/script"
PATH_LOG="/home/linus/log"

echo "[DISABLE HAVEGED...]"
systemctl stop haveged ;sleep 1

#restart ethercard
echo "[DISALBE IP_FORWARD...]"

echo "" > /home/linus/log/STAT

/home/linus/script/switch_proxy.sh block_hard
/home/linus/script/create_router.sh --disable-ap

/home/linus/script/my_log.sh "[${MY_ID}] Disconnect to LinusLAB-AP..."

/home/linus/script/my_wireless.sh wlx74da38b92029 enp8s8 temp_ap
