#!/bin/bash

cd /etc/tinyproxy/
cp tinyproxy.conf.deny tinyproxy.conf
/etc/init.d/tinyproxy restart
