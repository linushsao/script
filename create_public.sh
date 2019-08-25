#!/bin/bash

#exit 0
MY_ID="CREATE PUBLIC"

CONF_DIR="/home/linus/conf"
PATH_SCRIPT="/home/linus/script"

#restart ethercard
echo "[RESTART ETHER_CARD...]"

/home/linus/script/create_router.sh --disable-firewall

/home/linus/script/switch_proxy.sh unblock
 
/home/linus/script/my_log.sh "[${MY_ID}] Free Online Time..."

echo "ON" > /home/linus/log/STAT

${PATH_SCRIPT}/my_network.sh ap `cat ~/conf/WIRELESSIF_1` temp_ap
