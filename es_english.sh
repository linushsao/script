#!/bin/bash

#exit 0
FOLDER="/home/linus/es_english_now"
FOLDER_ALL="/home/linus/es_english"
MARK=""

case ${1} in
  "play_all") #PLAY ENGLISH_ALL
  echo "@@" > /home/linus/log/ES_PLAY
  until [ `cat /home/linus/log/ES_PLAY` == "" ]
  do
	for entry in `ls ${FOLDER_ALL}`; do
	if [ "`cat /home/linus/log/ES_PLAY`" == "" ];then
	exit 0
	fi
	#move pin to last ES
	echo $entry

	    	if [ "${MARK}" == "" ] && [ "`cat /home/linus/log/ES_CURRENT`" == "${entry}" ]
    		then
			MARK="${entry}"
		fi
 		if [ "${MARK}" != "" ];then
			mplayer "${FOLDER_ALL}/${entry}" -volume 70
			echo $entry > /home/linus/log/ES_CURRENT
			/home/linus/script/my_log.sh " ES_ENGLISH_PLAYALL:play ${entry}..."
		fi
	done
  done
	;;
  "play") #PLAY ENGLISH
  echo "@@" > /home/linus/log/ES_PLAY
  until [ `cat /home/linus/log/ES_PLAY` == "" ]
  do
	for entry in `ls ${FOLDER}`; do
	        if [ "`cat /home/linus/log/ES_PLAY`" == "" ];then
	        exit 0
       		fi
    		#echo $entry
		mplayer "${FOLDER}/${entry}" -volume 70
	done
  done

	/home/linus/script/my_log.sh " ES_ENGLISH_PLAY:play ${entry}..."

	;;

  "stop") #STOP ENGLISH

	echo "" > /home/linus/log/ES_PLAY
        /home/linus/script/kill_ap.sh mplayer
	;;

  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	echo "You MUST input parameters, ex> {${0} <play/stop>}"
	;;
esac
