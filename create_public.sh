#!/bin/bash

#exit 0
MY_ID="CREATE PUBLIC"

CONF_DIR="/home/linus/conf"

#restart ethercard
echo "[RESTART ETHER_CARD...]"

/home/linus/script/create_router.sh

/home/linus/script/switch_proxy.sh unblock
 
/home/linus/script/my_log.sh "[${MY_ID}] Free Online Time..."

echo "ON" > /home/linus/log/STAT

/home/linus/script/my_wireless.sh wlx74da38b92029 enp8s8 temp_ap
