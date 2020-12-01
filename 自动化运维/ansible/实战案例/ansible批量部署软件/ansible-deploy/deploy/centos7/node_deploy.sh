#!/bin/bash
#description: node一键安装脚本(仅适用于centos7)...
#version: v1.2
#auth: by zhengxin20180720
#email: hzzxin@tairanchina.com

SOURCE_DIR="/ansible-deploy/deploy/centos7"

##加载环境变量和函数
source $SOURCE_DIR/define_env.sh

##定义菜单函数
NODE_MENU() {
    clear
    echo -e "++++++++++++++ node软件批量部署菜单 ++++++++++++++"
    echo
    echo -e "\033[31;49;1m1.[node-v6.11.2 安装]\033[0m\n"
    echo -e "\033[32;49;1m2.[node-v8.10.0 安装]\033[0m"
    echo
    echo -e "++++++++++++++ node软件批量部署菜单 ++++++++++++++"
}

##打印软件部署菜单
NODE_MENU
sleep 1

read -p "please input your choice: " CHOICE

case $CHOICE in
1)
    EXEC_PLAYBOOK="$NODE1_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
2)
    EXEC_PLAYBOOK="$NODE2_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
*)
    echo "Usage: $0: {1 | 2}..."
    exit 1
    ;;
esac

exit 0  
