#!/bin/bash
#description: 显示应用版本信息脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##define variables
PROJ_NAME="ocs"
APP_GROUP="prd-lx-passport_tomcat-rest-part02"
ANSIBLE_CMD="/usr/bin/ansible"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_rest-${PROJ_NAME}.sh"

##ping检测
CHECK_PING() {
    $ANSIBLE_CMD "$1" -m ping &>/dev/null
    if [ $? -ne 0 ];then
	echo "$1 ping is failed,please check..."
	exit 1
    fi
}

##列出应用版本信息
LIST() {
    CHECK_PING $APP_GROUP

    ##列出最近版本
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "sh $UPDATE_SCRIPT list"
}

##主函数
LIST
