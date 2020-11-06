#!/bin/bash
#description: yum仓库repo文件一键安装脚本...
#version: v1.2
#auth: by zhengxin20180720
#email: hzzxin@tairanchina.com

SOURCE_DIR="/ansible-deploy/deploy/centos6"

##加载环境变量和函数
source $SOURCE_DIR/define_env.sh

##定义菜单函数
REPO_MENU() {
    clear
    echo -e "++++++++++++++ yum源repo文件批量部署菜单 ++++++++++++++"
    echo
    echo -e "\033[31;49;1m1.[本地yum源安装]\033[0m\n"
    echo -e "\033[32;49;1m2.[国内yum源(阿里云)安装]\033[0m"
    echo
    echo -e "++++++++++++++ yum源repo文件批量部署菜单 ++++++++++++++"
}

##打印软件部署菜单
REPO_MENU
sleep 1

read -p "please input your choice: " CHOICE

case $CHOICE in
1)
    EXEC_PLAYBOOK="$LOCAL_REPO_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
2)
    EXEC_PLAYBOOK="$ALY_REPO_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
*)
    echo "Usage: $0: {1 | 2}..."
    exit 1
    ;;
esac

exit 0  
