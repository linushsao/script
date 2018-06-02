#!/bin/bash

cd /etc/tinyproxy/
cp tinyproxy.conf.allow tinyproxy.conf
/etc/init.d/tinyproxy restart
