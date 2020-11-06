#!/bin/bash
SOURCE_DIR="/usr/local/weihu/passport_nginx-log-analyze"

##引用脚本
. $SOURCE_DIR/analyze_scripts/input_date.sh
. $SOURCE_DIR/analyze_scripts/record_top_ip.sh
. $SOURCE_DIR/analyze_scripts/record_top_url.sh
. $SOURCE_DIR/analyze_scripts/record_http_code.sh
. $SOURCE_DIR/analyze_scripts/record_per_ip_info.sh
. $SOURCE_DIR/analyze_scripts/record_per_code_info.sh
. $SOURCE_DIR/analyze_scripts/record_view.sh

###选择菜单
#MENU() {
#    clear
#    echo -e "+++++++++++++++++++ All Day +++++++++++++++++++"
#    echo
#    echo -e "\033[31;49;1m1.[print top 20 ip]\033[0m\n"
#    echo -e "\033[32;49;1m2.[print top 20 url]\033[0m\n"
#    echo -e "\033[33;49;1m3.[print http code info]\033[0m\n"
#    echo -e "\033[34;49;1m4.[print per_ip info]\033[0m\n"
#    echo -e "\033[35;49;1m5.[print per_code info]\033[0m\n"
#    echo -e "\033[36;49;1m6.[print view info]\033[0m\n"
#    echo
#    echo -e "+++++++++++++++++++ All Day +++++++++++++++++++"
#}
#
###打印更新菜单
#MENU
#echo
#sleep 1

##准备工作
INPUT_DATE "$1"

##主程序
#read -p "please input your choice: " CHOICE
CHOICE="$2"

case $CHOICE in
1)
    echo -e "All Day: print top 20 ip: "
    RECORD_IP "${ACCESS_FILE}"
    ;;
2)
    echo -e "All Day: print top 20 url: "
    RECORD_URL "${ACCESS_FILE}"
    ;;
3)
    echo -e "All Day: print http code info: "
    RECORD_HTTP_CODE "${ACCESS_FILE}"
    ;;
4)
    echo -e "All Day: print per_ip info: "
    RECORD_IP "${ACCESS_FILE}" &>/dev/null
    RECORD_PER_IP_INFO "${ACCESS_FILE}"
    ;;
5)
    echo -e "All Day: print per_code info: "
    RECORD_HTTP_CODE "${ACCESS_FILE}" &>/dev/null
    RECORD_PER_CODE_INFO "${ACCESS_FILE}"
    ;;
6)
    echo -e "All Day: print view info: "
    RECORD_ACCESS_VISITS "${ACCESS_FILE}"
    ;;
*)
    echo "USAGE: ${0}: { 1 | 2 | 3 | 4 | 5 | 6 }..."
    exit 1
    ;;
esac

    
