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
		#move pin to last ES
    	if [ ${MARK} == "" ] && [ `/home/linus/log/ES_CURRENT` == "${entry}" ]
    	then
			MARK="${entry}"
		fi
    	if [ "${MARK}" ~= "" ];then
			mplayer "${FOLDER_ALL}/${entry}"
			echo $entry > /home/linus/log/ES_CURRENT
			/home/linus/script/my_log.sh " ES_ENGLISH:play ${entry}..."
		fi
	done
  done
	;;
  "play") #PLAY ENGLISH
  echo "@@" > /home/linus/log/ES_PLAY
  until [ `cat /home/linus/log/ES_PLAY` == "" ]
  do
	for entry in `ls ${FOLDER}`; do
    		#echo $entry
		mplayer "${FOLDER}/${entry}"
	done
  done

	/home/linus/script/my_log.sh " ES_ENGLISH:play ${entry}..."

	;;

  "stop") #STOP ENGLISH

	object="mplayer"
	filter=" "
	echo "" > /home/linus/log/ES_PLAY
	until [ "${filter}" == "" ]  
  		do
    		filter=`pidof ${object}`
    		kill ${filter} ;sleep 1
	done

	/home/linus/script/my_log.sh " ES_ENGLISH:terminated..."

	;;

  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	echo "You MUST input parameters, ex> {${0} <play/stop>}"
	;;
esac
