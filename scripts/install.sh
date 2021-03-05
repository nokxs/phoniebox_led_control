#!/bin/bash
# Colors: \e[36m=Cyan M ; \e[92m=Light green ; \e[91m=Light red ; \e[93m=Light yellow ; \e[31m=green ; \e[0m=Default ; \e[33m=Yellow ; \e[31m=Red

#Version: 1.9.3 - 20210305
#branch="development"
repo="https://github.com/splitti/button_led_control/"
branch="master"

nocolor='\e[0m'
red="\e[1;91m"
cyan="\e[1;36m"
yellow="\e[1;93m"
green="\e[1;92m"
installPath="/home/pi/oled_phoniebox"

clear
echo -e "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}                                                                                                             ${nocolor}///";
echo -e "///${cyan} ██████╗ ██╗  ██╗ ██████╗ ███╗   ██╗██╗███████╗██████╗  ██████╗ ██╗  ██╗    ██╗     ███████╗██████╗          ${nocolor}///";
echo -e "///${cyan} ██╔══██╗██║  ██║██╔═══██╗████╗  ██║██║██╔════╝██╔══██╗██╔═══██╗╚██╗██╔╝    ██║     ██╔════╝██╔══██╗         ${nocolor}///";
echo -e "///${cyan} ██████╔╝███████║██║   ██║██╔██╗ ██║██║█████╗  ██████╔╝██║   ██║ ╚███╔╝     ██║     █████╗  ██║  ██║         ${nocolor}///";
echo -e "///${cyan} ██╔═══╝ ██╔══██║██║   ██║██║╚██╗██║██║██╔══╝  ██╔══██╗██║   ██║ ██╔██╗     ██║     ██╔══╝  ██║  ██║         ${nocolor}///";
echo -e "///${cyan} ██║     ██║  ██║╚██████╔╝██║ ╚████║██║███████╗██████╔╝╚██████╔╝██╔╝ ██╗    ███████╗███████╗██████╔╝         ${nocolor}///";
echo -e "///${cyan} ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝    ╚══════╝╚══════╝╚═════╝          ${nocolor}///";
echo -e "///${cyan}                                                                                                             ${nocolor}///";
echo -e "///${cyan}                      ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  ██████╗ ██╗                                ${nocolor}///";
echo -e "///${cyan}                     ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗██║                                ${nocolor}///";
echo -e "///${cyan}                     ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║██║                                ${nocolor}///";
echo -e "///${cyan}                     ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║██║                                ${nocolor}///";
echo -e "///${cyan}                     ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝███████╗                           ${nocolor}///";
echo -e "///${cyan}                      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝                           ${nocolor}///";
echo -e "///${cyan}                                                                                                             ${nocolor}///";
echo -e "///${cyan}                                                                                                             ${nocolor}///";
echo -e "////////////////////////////////////////////////////////////////////////////////////////////////////////////////////"
echo -e "///                                                                                                              ///"
echo -e "///${cyan}                                  https://github.com/splitti/button_led_control/                                   ${nocolor}///"
echo -e "///                                                                                                              ///"
echo -e "////////////////////////////////////////////////////////////////////////////////////////////////////////////////////"
echo -e ""
echo -e "${red}Please notice:${nocolor} This script will install a Service to animate button leds."
echo -e " "
echo -e "Do you want to install this Service?"
echo -e " "
options=("Install" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Install")
            break
            ;;

        "Quit")
            exit
            ;;
        *) echo -e "invalid option $REPLY";;
    esac
done

clear
echo -e "////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}   Please choose your animation type:                         ${nocolor}///"
echo -e "////////////////////////////////////////////////////////////////////"
echo -e ""
echo -e "Choose your type of animation:"
echo -e " "
options=("1 Knight Rider" "2 Star Trek" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "1 Knight Rider")
			echo -e ""
            ani_type="1"
			echo -e " "
            break
            ;;
        "2 Star Trek")
            echo -e ""
            ani_type="2"
			echo -e " "
            break
            ;;
        "Quit")
            exit
            ;;
        *) echo -e "Invalid option $REPLY";;
    esac
done

clear
cd
echo -e "////////////////////////////////////////////////////////////////////"
echo -e "///${cyan}   Installing...                                              ${nocolor}///"
echo -e "////////////////////////////////////////////////////////////////////"
echo -e " "

lineLen=28
packages=(git python3 python3-gpiozero)
for p in ${packages[@]}; do
	i=0
	echo -n -e "   --> $p:"
    let lLen="$lineLen"-"${#p}"
    while [ "$i" -lt "$lLen" ]
    do
		let i+=1
		echo -n -e " "
	done
    installer=`sudo dpkg -s ${p}  2>&1 | grep Status | grep installed`
    if [ "$installer" = "" ]
    then
		installer=`sudo apt -qq -y install ${p} > /dev/null 2>&1`
		installer=`sudo dpkg -s ${p} 2>&1 | grep Status | grep installed`
		if [ "$installer" = "" ]
		then
			echo -e "${red}failed${nocolor}"
		else
			echo -e "${green}done${nocolor}"
		fi
	else
		echo -e "${green}already installed${nocolor}"
	fi
done
echo -n -e "   --> Delete existing service:"
echo -n -e "   --> Create Directory:"
echo -n -e "   --> Downloading Files:"
echo -n -e "   --> Installing Service:"
echo -e ""
read -n 1 -s -r -p "Press any key to continue"


