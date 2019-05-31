#!/bin/bash
#set -e
set -x
#: Title : radiostreams
#: Date : February 2015
#: Author : Sharon Kimble
#: Version : 4.0
#: Description : to give a comprehensive set of MPD radio stations

# Copyright (C) 2014, 2015 Sharon Kimble
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
####################################################
# Changelog.
# * 08-02-2014 - v2.0 - Enlarged the list of radio streaming sites
# * 11-02-2014 - v2.1 - Changed the variable so it runs better
# * 26-12-2014 - v3.0 - Uses new BBC radio feeds
# * - v3.5 - added in some Christian feeds
# * 11-02-2015 - v4.0 - Added in new BBC feeds, and removed dead feeds
####################################################
# Variables
playlistdir=~/.mpd/playlists
####################################################

declare -A radios
radios["BBC Radio 2"]="http://www.radiofeeds.co.uk/bbcradio2.pls"
radios["BBC Radio 3"]="http://www.radiofeeds.co.uk/bbcradio3.pls"
radios["BBC Radio 4 longwave"]="http://www.radiofeeds.co.uk/bbcradio4lw.pls"
radios["BBC Radio 4 extra"]="http://www.radiofeeds.co.uk/bbcradio4extra.pls"
radios["BBC 5 live"]="http://www.radiofeeds.co.uk/bbc5live.pls"
radios["BBC Radio Kent"]="http://www.radiofeeds.co.uk/bbcradiokent.pls"
radios["Irelands Kiss FM"]="http://uk1.internet-radio.com:15476/listen.pls"
radios["Amazing smooth and jazz"]="http://uk1.internet-radio.com:4086/listen.pls"
radios["Ambient chillout"]="http://uk2.internet-radio.com:31491/listen.pls"
radios["Champion Radio UK"]="http://uk2.internet-radio.com:31216/listen.pls"
radios["Chillout Lounge Radio"]="http://sc-tcl.1.fm:8010/listen.pls"
radios["181 FM - Highway 181"]="http://uplink.duplexfx.com:8018/listen.pls"
radios["181.FM - Christmas Traditional Classics"]="http://uplink.duplexfx.com:8124/listen.pls"
radios["North Pole Radio"]="http://ophanim.net:9790/listen.pls"
radios["181.FM - Christmas Power - Top 40 Christmas Hits"]="http://uplink.duplexfx.com:8086/listen.pls"
radios["Nirvana Radio - Music for Meditation and Relaxation"]="http://sc9106.xpx.pl:9106/listen.pls"
radios["bas FM"]="http://uk2.internet-radio.com:30274/listen.pls"
radios["Horizon Fm - Tenerife"]="http://uk1.internet-radio.com:15614/listen.pls"
radios["Metal Express"]="http://usa7-vn.mixstream.net/listen/8248.pls"
radios["spiritsplantsradio"]="http://streams.museter.com:2199/tunein/cenacle.pls"
radios["Abacus FM - Goon Shows"]="http://91.121.166.38:7690/listen.pls"
radios["Demented Radio"]="http://dementedradio.streamguys.us:8000/listen.pls"
radios["Cabin Boy Comedy Club"]="http://majestic.wavestreamer.com:3547/listen.pls"
radios["Kiss FM Hits"]="http://uk3.internet-radio.com:10911/listen.pls"
radios["Stagescripts Internet Radio"]="http://uk2.internet-radio.com:30591/listen.pls"
radios["Cool Fahrenheit 93"]="http://203.150.224.142:8003/listen.pls"
radios["KLUX 89.5HD"]="http://s4.viastreaming.net:7610/listen.pls"
radios["Angel Radio"]="http://s8.viastreaming.net:7030/listen.pls"
radios["EZ Does It Net Radio"]="http://mega6.radioserver.co.uk:8172/listen.pls"
radios["Pinetrees"]="http://sc05.saycast.com:8280/listen.pls"
radios["181 FM - Golden Oldies"]="http://uplink.duplexfx.com:8046/listen.pls"
radios["Beatles Radio"]="http://www.beatlesradio.com:8088/listen.pls"
radios["EP Express - The Elvis Presley Radio Station"]="http://s2.fastcast4u.com:9246/listen.pls"
radios["Christian Rock"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=583498"
radios["A better Christmas Radio Station"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=265065"
radios["ChristianRock"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=68102"
radios["Praiseworld Radio"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=235618"
radios["I am Christian"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=170693"
radios["Faith Renewed"]="http://yp.shoutcast.com/sbin/tunein-station.pls?id=24049"

echo
for k in "${!radios[@]}"
do
filepath="${playlistdir}/${k}.m3u"
rm -f "$filepath"
echo "#EXTM3U" >> "$filepath"
pls=${radios[$k]}
echo "#EXTINF:-1, BBC - $k" >> "$filepath"
/usr/bin/curl -s $pls | grep File1 | sed 's/File1=\(.*\)/\1/' >> "$filepath"
done

