#!/bin/bash
#description: 通过ansible实现批量部署软件入口主程序...
#version: v1.2
#auth: by zhengxin20180720
#email: hzzxin@tairanchina.com

##定义变量
CENTOS6_INVENTORY="/ansible-deploy/inventory/centos6_ip_list"
CENTOS7_INVENTORY="/ansible-deploy/inventory/centos7_ip_list"
CENTOS6_DEPLOY="/ansible-deploy/deploy/centos6/deploy.sh"
CENTOS7_DEPLOY="/ansible-deploy/deploy/centos7/deploy.sh"


##定义菜单函数
OS_MENU() {
    clear
    echo -e "++++++++++++++ 生产环境软件批量部署主菜单 ++++++++++++++"
    echo
    echo -e "\033[31;49;1m1.[centos6 系统]\033[0m\n"
    echo -e "\033[32;49;1m2.[centos7 系统]\033[0m"
    echo
    echo -e "++++++++++++++ 生产环境软件批量部署主菜单 ++++++++++++++"
}


##检测ansible是否已经安装
CHECK_ANSIBLE() {
    if ! rpm -qa | grep ansible &>/dev/null;then
        yum install ansible -y &>/dev/null
	if ! which ansible &>/dev/null;then
	    echo "install ansible failure,please check..."
	    exit 1
	fi
    fi
}

##检测文件
CHECK_FILE() {
    if [ -f $1 ];then
        if [ ! -s $1 ];then
	    echo "inventory file is empty..."
            exit 1
        fi
    else
	echo "inventory file does not exist..."
        exit 1
    fi
}

##检测目标主机是否已经加入ansible管理
CHECK_PING() {
    FAILURE_HOSTS=$(ansible -i "$1" all -m ping -o | grep -vi "success" | awk '{print $1}') 
    if [ x"$FAILURE_HOSTS" != x"" ];then
        echo -e "\033[31;49;1m\nHosts do not join anisble management As follow: \033[0m"
	echo "$FAILURE_HOSTS"
	exit 1
    fi    	
}


##主程序
CHECK_ANSIBLE

##打印菜单
OS_MENU
sleep 1

read -p "please select os environment: " ENV

case $ENV in
1)
    CHECK_FILE $CENTOS6_INVENTORY
    CHECK_PING $CENTOS6_INVENTORY
    sh $CENTOS6_DEPLOY
    ;;
2)
    CHECK_FILE $CENTOS7_INVENTORY
    CHECK_PING $CENTOS7_INVENTORY
    sh $CENTOS7_DEPLOY
    ;;
*)
    echo "Usage: $0: {1 | 2}..."
    exit 1
    ;;
esac

exit 0  
