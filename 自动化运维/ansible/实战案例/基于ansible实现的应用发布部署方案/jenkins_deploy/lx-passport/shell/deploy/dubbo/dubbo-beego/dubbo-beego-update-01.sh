#!/bin/bash
#description: 律信用户阿里云环境dubbo一键更新脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##Source download-pkgfile.sh
. /jenkins_deploy/lx-passport/shell/download-pkgfile.sh

##define variables
PROJ_NAME="dubbo-beego"
APP_GROUP="prd-lx-passport_dubbo-beego-part01"
ANSIBLE_CMD="/usr/bin/ansible"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_dubbo-beego.sh"
LOCAL_PKG_DIR="/jenkins_deploy/lx-passport/sftp/${DATE}/${PROJ_NAME}"
DST_TMP_DIR="/data/update/pkg/dubbo_tmp"
UPDATE_LOG_DIR="/jenkins_deploy/lx-passport/logs/update/dubbo/${PROJ_NAME}/part01"
TIMESTAMPS=$(date +%Y%m%d%H%M)

##ping检测
CHECK_PING() {
    $ANSIBLE_CMD "$1" -m ping &>/dev/null
    if [ $? -ne 0 ];then
	echo "ping is failed,please check..."
	exit 1
    fi
}

##传输更新包
TRANSPORT_PKG() {
    ##从包仓库下载最新的更新包文件,并保存到本地目录
    DOWNLOAD_PER_PKG $PROJ_NAME
    ##获取更新包文件
    PKG_FILE=$(find $LOCAL_PKG_DIR -name "${PROJ_NAME}*" -type f | xargs ls -r | head -1)
    ##传输更新包文件
    echo "Now,transport pkg file to remote server..."
    $ANSIBLE_CMD $APP_GROUP -m copy -a "src=$PKG_FILE dest=$DST_TMP_DIR/"
}

##更新
UPDATE() {
    CHECK_PING $APP_GROUP
    TRANSPORT_PKG

    ##创建应用日志目录及日志文件
    mkdir -p ${UPDATE_LOG_DIR}
    UPDATE_LOG_FILE="${UPDATE_LOG_DIR}/update.log-${TIMESTAMPS}"
    >$UPDATE_LOG_FILE
    
    echo "${PROJ_NAME}应用更新开始: " | tee -a $UPDATE_LOG_FILE
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "sh $UPDATE_SCRIPT deploy" | tee -a $UPDATE_LOG_FILE
}

##main
UPDATE
