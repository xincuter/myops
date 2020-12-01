#!/bin/bash
#decription: 律信用户中心阿里云环境nginx前端应用一键更新脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##Source download-pkgfile.sh
. /jenkins_deploy/lx-passport/shell/download-pkgfile.sh

##define variables
PROJ_NAME="account"
ANSIBLE_CMD="/usr/bin/ansible" 
APP_GROUP="prd-lx-passport_nginx"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_nodejs-${PROJ_NAME}.sh"
LOCAL_PKG_DIR="/jenkins_deploy/lx-passport/sftp/${DATE}/nodejs/${PROJ_NAME}"
DST_TMP_DIR="/data/update/pkg/nodejs_tmp"
UPDATE_LOG_DIR="/jenkins_deploy/lx-passport/logs/update/nginx/nodejs/$PROJ_NAME"
TIMESTAMPS=$(date +%Y%m%d%H%M)

##ping检测
CHECK_PING() {
    $ANSIBLE_CMD "$1" -m ping &>/dev/null
    if [ $? -ne 0 ];then
	echo "$1 ping is failed,please check..."
	exit 1
    fi
}

##传输更新包
TRANSPORT_PKG() {
    ##从包仓库下载最新的更新包文件,并保存到本地目录
    DOWNLOAD_PER_PKG nodejs/$PROJ_NAME
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

    echo "${APP_NAME}应用更新开始: " | tee -a $UPDATE_LOG_FILE
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "source /etc/profile;sh $UPDATE_SCRIPT deploy" | tee -a $UPDATE_LOG_FILE   
}

##main
UPDATE
