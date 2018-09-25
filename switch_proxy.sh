#!/bin/bash

case $1 in
	"block")
	CHECK="whitelist"
	;;
	"block_hard")
	CHECK="whitelist_hard"
	;;
	"unblock")
	CHECK="nowhitelist"
	;;
	*)
	echo "no param(block/unblock)"
	exit 0
	;;
esac

echo "[Launch Proxy $CHECK ...]"

cd /etc/tinyproxy
cp tinyproxy.conf.${CHECK} tinyproxy.conf
#killall tinyproxy;sleep 1
#/home/linus/src/tinyproxy/bin/tinyproxy -c /etc/tinyproxy/tinyproxy.conf -d &
systemctl stop tinyproxy
sleep 1
systemctl start tinyproxy

/home/linus/script/my_log.sh " ENABLE PROXY ${CHECK}..."
