#!/bin/bash

#exit 0
FOLDER="/home/linus/es_english_now"

case ${1} in
  "play") #PLAY ENGLISH
	for entry in `ls ${FOLDER}`; do
    		#echo $entry
		mplayer "${FOLDER}/${entry}"
	done

	/home/linus/script/my_log.sh " ES_ENGLISH:play ${entry}..."

	;;

  "stop") #STOP ENGLISH

	object="mplayer"
	filter=" "

	until [ "${filter}" == "" ]  
  		do
    		filter=`pidof ${object}`
    		kill ${filter} ;sleep 1
    		echo $filter
	done

	/home/linus/script/my_log.sh " ES_ENGLISH:terminated..."

	;;

  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	echo "You MUST input parameters, ex> {${0} <play/stop>}"
	;;
esac
