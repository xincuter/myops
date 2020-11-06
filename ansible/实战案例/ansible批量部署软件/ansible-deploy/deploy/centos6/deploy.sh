#!/bin/bash
#description: 通过ansible实现批量部署应用环境主程序(仅适用于centos6)...
#version: v1.2
#auth: by zhengxin20180720
#email: hzzxin@tairanchina.com

SOURCE_DIR="/ansible-deploy/deploy/centos6"
NODE_SCRIPT="$SOURCE_DIR/node_deploy.sh"
REPO_SCRIPT="$SOURCE_DIR/repo_deploy.sh"

##加载环境变量和函数
source $SOURCE_DIR/define_env.sh

##定义软件安装菜单
MENU() {
    clear
    echo -e "++++++++++++++ centos6系统软件批量部署菜单 ++++++++++++++"
    echo
    echo -e "\033[31;49;1m1.[系统环境初始化]\033[0m\n"
    echo -e "\033[32;49;1m2.[yum源初始化]\033[0m\n"
    echo -e "\033[33;49;1m3.[jdk软件安装]\033[0m\n"
    echo -e "\033[34;49;1m4.[node软件安装]\033[0m\n"
    echo -e "\033[35;49;1m5.[nginx软件安装]\033[0m\n"
    echo -e "\033[36;49;1m6.[rabbitmq软件安装]\033[0m\n"
    echo -e "\033[37;49;1m7.[tomcat软件安装]\033[0m\n"
    echo -e "\033[38;49;1m8.[zookeeper软件安装(standalone)]\033[0m\n"
    echo -e "\033[31;42;1m9.[zabbix-agent软件安装]\033[0m"
    echo
    echo -e "++++++++++++++ centos6系统软件批量部署菜单 ++++++++++++++"
}

##主程序
CHECK_FILE

##打印软件部署菜单
MENU
sleep 1

read -p "please input your choice: " CHOICE

case $CHOICE in
1)
    EXEC_PLAYBOOK="$ENV_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK 
    ;;
2)
    sh $REPO_SCRIPT
    ;;
3)
    EXEC_PLAYBOOK="$JDK_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
4)
    sh $NODE_SCRIPT
    ;;
5)
    EXEC_PLAYBOOK="$NGINX_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
6)
    EXEC_PLAYBOOK="$MQ_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;    
7)
    EXEC_PLAYBOOK="$TOMCAT_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
8)
    EXEC_PLAYBOOK="$ZK_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
9)
    EXEC_PLAYBOOK="$ZBX_AGENT_PLAYBOOK"
    INSTALL $EXEC_PLAYBOOK
    ;;
*)
    echo "Usage: $0: {1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9}..."
    exit 1
    ;;
esac

exit 0  
