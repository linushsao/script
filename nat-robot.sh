#!/bin/bash
# Program:linushsao@gmail.com

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

HOME_PATH="/home/linus/"
ALL_CMD="[available cmd: check/network/log/flag/tools/help]"
RETURN_TXT="Pls press any key to return main menu. "
EXT_INF="enp2s0f1"
IN_INF="wlp3s0"


NAME="AUSTIN ROSE"

##ALL FUNCTIONS

flag_modify () {

		for n in $NAME
		do
			echo "${n}'s ${check_flag} :"`cat ${check_flag}_${n}`
		done
		echo
		read -p "Who's ${check_flag} do you like to modify : " ans2
			for n in $NAME
				do
				if [ "${n}" == "${ans2}" ]; then
					read -p "pls input the new value of ${ans2}'s ${check_flag} : " ans3
					echo "${ans3}" > ./${check_flag}_"${ans2}"
					echo "${ans2}'s ${check_flag} :"`cat ${check_flag}_${ans2}`
					check_flag="TRUE"
					#mark for child could add nc by themself
					touch mark_${ans2}
				fi
			done
		if [ "${check_flag}" != "TRUE" ]; then
			echo "Wrong Params : $ans2 $ans3"
		fi
	
}

flag_remove () {

		read -p "Who's ${check_flag} data do you wanna ${check_flag1}(<NAME>/all/exit): " ans1
			if [ ${ans1} == "all" ]; then
				for n in $NAME
				do
					rm ${check_flag}_${n}
					echo "${check_flag} of ${n} ${check_flag1} completely."
				done
			else
				for n in $NAME
				do
					if [ ${n} == ${ans1} ]; then
					rm ${check_flag}_${n}
					echo "${check_flag} of ${n} ${check_flag1} completely."
					fi
				done
			fi

}

flag_add () {

		read -p "Who's ${check_flag} data do you wanna ${check_flag1}(<NAME>/all/exit): " ans1
			if [ ${ans1} == "all" ]; then
				for n in $NAME
				do
					touch ${check_flag}_${n}
					echo "${check_flag} of ${n} ${check_flag1} completely."
				done
			else
				for n in $NAME
				do
					if [ ${n} == ${ans1} ]; then
					touch ${check_flag}_${n}
					echo "${check_flag} of ${n} ${check_flag1} completely."
					fi
				done
			fi

}

check_switch () {

			if [ "`ls -al | grep switch_${check_flag}`" == "" ]; then
			echo "${check_flag}'s SWITCH :OFF"
			else
			echo "${check_flag}'s SWITCH :ON"
			fi

}

##

##MAIN

cd ${HOME_PATH}/log

until [ "${ans}" == "exit" -o "${ans}" == "e" ]
do
	clear;unset ans1
	echo "###############WELCOME TO LINUS's PLANET#################"
	echo 
	echo "Hi, i'm LISA ,nice to meet you." ;echo
	echo ${ALL_CMD}
	read -p "Please input command or (e)xit to exit this program: " ans

case ${ans} in
 
  "check") #check data
	until [ "${ans1}" == "exit" -o "${ans1}" == "e" ]
	do
				for n in $NAME
					do
				echo "${n}'s TC :"`cat tc_${n}`
				echo "${n}'s NC :"`cat nc_${n}`
				echo "${n}'s TL :"`cat tl_${n}`
				check_flag="${n}"
				check_switch
				done
		read -p "$RETURN_TXT" ans1
	done

	;;
 
  "network") #check network

	until [ "${ans1}" == "exit" -o "${ans1}" == "e" ]
	do
		read -p "What network data do you wanna check(param/force-restart/qscan/iwconfig/ifconfig/ifup/ifdown/interface/generate_wpa(gw)/network_mode(nm)/exit): " ans1
		echo "--------------------------------------------"
			if [ ${ans1} == "param" ]; then
				echo "Current filter param :"`cat ./para`
			elif [ ${ans1} == "force-restart" ]; then
				sudo /${HOME_PATH}script/run-nat-filter-reset.sh
			elif [ ${ans1} == "qscan" ]; then
				nmap -sP 192.168.0.50-100
			elif [ ${ans1} == "iwconfig" ]; then
				iwconfig
			elif [ ${ans1} == "ifconfig" ]; then
				ifconfig
			elif [ ${ans1} == "ifup" ]; then
				read -p "What network interface do you wanna bring up: " ans2
				sudo ifconfig ${ans2} up
			elif [ ${ans1} == "ifdown" ]; then
				read -p "What network interface do you wanna bring down: " ans2
				sudo ifconfig ${ans2} down
			elif [ ${ans1} == "interface" ]; then
				echo "Current EXT-INTERFACE :"${EXT_INF}
				echo "Current IN-INTERFACE :"${IN_INF}
				read -p "What network interface do you wanna modify(ext-inf/in-inf): " ans2
				if [ "$ans2" == "ext-inf" ]; then
					read -p "pls input the new name of interface ${ans2}: " ans3
					if [ "$ans3" != "" ]; then
						EXT_INF="${ans3}"
					fi
				elif [ "$ans2" == "in-inf" ]; then
					read -p "pls input the new name of interface ${ans2}: " ans3
					if [ "$ans3" != "" ]; then
						IN_INF="${ans3}"
					fi
				fi
				echo "Current EXT-INTERFACE :"${EXT_INF}
				echo "Current IN-INTERFACE :"${IN_INF}
			elif [ ${ans1} == "gw" ]; then
					echo "CURRENT WIRELESS CONFIGURE..."
					cat ${HOME_PATH}script/now.conf
					read -p "ESSID:" ans2
					read -p "PASSWD:" ans3
					wpa_passphrase ${ans2} ${ans3} > ${HOME_PATH}script/now.conf
					wpa_passphrase ${ans2} ${ans3} > ${HOME_PATH}script/${ans2}.conf
					echo "WPA_PASSPHRASE is GENERATED."
					cat ${HOME_PATH}script/now.conf
			elif [ ${ans1} == "nm" ]; then
					echo "Current Extra Network_mode :"`cat ${HOME_PATH}log/NETWORK_MODE`
					read -p "Add MOBILE Network(y/n)" ans2
					if [ "$ans2" == "y" ]; then
						echo "mobile" > ${HOME_PATH}log/NETWORK_MODE
						echo "MOBILE" > /home/linus/log/CHECK_NETWORK
					elif [ "$ans2" == "n" ]; then
						echo "" > ${HOME_PATH}log/NETWORK_MODE
						
					fi
					echo "New Extra Network_mode :"`cat ${HOME_PATH}log/NETWORK_MODE`
			fi

		echo
		read -p "$RETURN_TXT" tt
	done
	;;

  "log") #check network

	until [ "${ans1}" == "exit" -o "${ans1}" == "e" ]
	do
		read -p "What network data do you wanna check(filter/switch/exit): " ans1
		echo "--------------------------------------------"
			if [ ${ans1} == "filter" ]; then
				less net-filter.log
			elif [ ${ans1} == "switch" ]; then
				less switch.log
			fi
		echo
		read -p "$RETURN_TXT" tt
	done
	;;


  "flag") #check network
	unset ans1 ans2 ans3
	until [ "${ans1}" == "exit" -o "${ans1}" == "e" ]
	do
		read -p "What flag data do you wanna modify(extra_tl(ext)/extra_nethours(extn)/tc/nc/tl/switch/exit): " ans1
		echo "--------------------------------------------"
			if [ ${ans1} == "extra_tl" -o ${ans1} == "ext" ]; then
				echo "Current EXTRA_TL :"`cat EXTRA_TL`
				read -p "pls input the value of EXTRA_TL: " ans2
				if [ "$ans2" != "" ]; then
					echo $ans2 > ./EXTRA_TL
				fi
				echo "Current EXTRA_TL :"`cat EXTRA_TL`
			elif [ ${ans1} == "extra_nethours" -o ${ans1} == "extn" ]; then
				echo "Current EXTRA_NETHOURS :"`cat NETHOURS_EXTRA`
				unset ans2 ans3
				until [ "${ans2}" == "exit" -o "${ans2}" == "e" ]
				do
					read -p "What action do you wanna modify to extra_nethours(add/clear/standard(std)/exit): " ans2
					if [ "${ans2}" == "add" ]; then
						read -p "pls input the value of EXTRA_NETHOURS(day hour min-start min-stop):" ans3
						if [ "$ans3" != "" ]; then
							echo $ans3" " >> ./NETHOURS_EXTRA
						fi
					elif [ "${ans2}" == "clear" ]; then
							echo "" > ./NETHOURS_EXTRA
					elif [ "${ans2}" == "std" ]; then
							echo "" > ${HOME_PATH}log/NETHOURS.conf
					fi
					echo "Current EXTRA_NETHOURS :"`cat NETHOURS_EXTRA`
				done
			elif [ ${ans1} == "tc" ]; then
				check_flag="tc"
				flag_modify
			elif [ ${ans1} == "nc" ]; then
				check_flag="nc"
				flag_modify
			elif [ ${ans1} == "tl" ]; then
				check_flag="tl"
				flag_modify
			elif [ ${ans1} == "switch" ]; then
				check_flag="switch"
				read -p "switch should be ON or OFF(on/off): " ans2
				check_flag1="${ans2}"
				if [ "${ans2}" == "off" ];then
					flag_remove
				elif [ "${ans2}" == "on" ];then
					flag_add
				fi
			fi
		echo
		read -p "$RETURN_TXT" tt
	done
	;;

  "tools") 
	unset ans1 ans2 ans3
	until [ "${ans1}" == "exit" -o "${ans1}" == "e" ]
	do
		read -p "What tools do you wanna use it(addTC(tc)/addNC(nc)/rclone/exit): " ans1
		echo "--------------------------------------------"
			if [ ${ans1} == "tc" ]; then
				read -p "Who's tc do you wanna add: " ans2
				if [ "$ans2" != "" ]; then
					echo ${ans2}"has TC:"`cat ${HOME_PATH}log/tc_${ans2}`
					read -p "how much tc do you wanna add to ${ans2}: " ans3
					if [ "$ans3" != "" ]; then
						${HOME_PATH}script/nat-add-tc.sh ${ans2} ${ans3}
					fi
					echo ${ans2}" has TC:"`cat ${HOME_PATH}log/tc_${ans2}`
				fi
			elif [ ${ans1} == "nc" ]; then
				read -p "Who's nc do you wanna add: " ans2
				if [ "$ans2" != "" ]; then
					echo ${ans2}" has NC:"`cat ${HOME_PATH}log/nc_${ans2}`
					read -p "how much nc do you wanna add to ${ans2}: " ans3
					if [ "$ans3" != "" ]; then
						${HOME_PATH}script/nat-add-nc.sh ${ans2} ${ans3}
					fi
					echo ${ans2}"has NC:"`cat ${HOME_PATH}log/nc_${ans2}`
				fi
			elif [ ${ans1} == "rclone" ]; then
				read -p "local to google-driver(lg)/ google-driver to local(gl): " ans2
				if [ "$ans2" == "gl" ]; then
					rclone copy gdriver:GIT/git_reposi /home/linus/Downloads/gdriver/
				elif [ "$ans2" == "lg" ]; then
					rclone copy /home/linus/Downloads/gdriver/ gdriver:GIT/git_reposi
				fi

			fi
		echo
		read -p "$RETURN_TXT" tt
	done
	;;
	
  *)   # 其實就相當於萬用字元，0~無窮多個任意字元之意！
	;;
esac
	
done
echo "OK! see you later."
