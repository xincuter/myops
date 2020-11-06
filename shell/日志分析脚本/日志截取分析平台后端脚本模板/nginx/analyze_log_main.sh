#!/bin/bash
SOURCE_DIR="/usr/local/weihu/passport_nginx-log-analyze/analyze_scripts"
ALL_ANALYSE_SCRIPT="$SOURCE_DIR/all_day_main.sh"
PERIOD_ANALYSE_SCRIPT="$SOURCE_DIR/period_time_main.sh"

##选择菜单
MENU() {
    clear
    echo -e "++++++++++++++下沙金融用户中心nginx日志分析菜单++++++++++++++"
    echo
    echo -e "\033[33;49;1m1.[All day]\033[0m\n"
    echo -e "\033[34;49;1m2.[Period time]\033[0m"
    echo
    echo -e "++++++++++++++下沙金融用户中心nginx日志分析菜单++++++++++++++"
}

##打印更新菜单
#MENU
#echo
#sleep 1

##主程序
#read -p "please input your choice: " CHOICE
CHOICE=$1

case $CHOICE in
1)
    echo -e "you select All day..."
    sh ${ALL_ANALYSE_SCRIPT}
    ;;
2)
    echo -e "you select Period time..."
    sh ${PERIOD_ANALYSE_SCRIPT}
    ;;
*)
    echo "USAGE: ${0}: { 1 | 2 }..."
    exit 1
    ;;
esac

    
