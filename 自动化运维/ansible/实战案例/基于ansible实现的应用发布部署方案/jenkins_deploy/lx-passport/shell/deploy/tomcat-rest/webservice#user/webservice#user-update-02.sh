#!/bin/bash
#description: tomcat-rest一键更新脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##Source download-pkgfile.sh
. /jenkins_deploy/lx-passport/shell/download-pkgfile.sh

##define variables
PROJ_NAME="webservice#user"
APP_GROUP="prd-lx-passport_tomcat-rest-part02"
ANSIBLE_CMD="/usr/bin/ansible"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_rest-${PROJ_NAME}.sh"
NGINX_CONF_DIR="/jenkins_deploy/lx-passport/nginx"
UPSTREAM_FILE="${NGINX_CONF_DIR}/upstream_passrest.conf-part02"
NGINX_SERVER="10.206.188.23"
LOCAL_PKG_DIR="/jenkins_deploy/lx-passport/sftp/${DATE}/${PROJ_NAME}"
DST_TMP_DIR="/data/update/pkg/tomcat_tmp"
UPDATE_LOG_DIR="/jenkins_deploy/lx-passport/logs/update/tomcat/$PROJ_NAME/part02"
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
    DOWNLOAD_PER_PKG $PROJ_NAME
    ##获取更新包文件
    PKG_FILE=$(find $LOCAL_PKG_DIR -name "${PROJ_NAME}*" -type f | xargs ls -r | head -1)
    ##传输更新包文件
    echo "Now,transport pkg file to remote server..."
    $ANSIBLE_CMD $APP_GROUP -m copy -a "src=$PKG_FILE dest=$DST_TMP_DIR/"
}

##nginx下线第2批passrest服务,上线第1批passrest服务
NGINX_OFFLINE() {
    $ANSIBLE_CMD "$NGINX_SERVER" -m copy -a "src=$UPSTREAM_FILE dest=/usr/local/nginx/conf.d/upstream/upstream_passrest.conf" &>/dev/null
    if [ $? -eq 0 ];then
	CHECK_INFO=$(ssh root@$NGINX_SERVER "service nginx check 2>/dev/null")
	if echo "$CHECK_INFO" | grep "nginx check failed" &>/dev/null;then
	    echo "nginx configuration file check failed,please check..."
	    exit 1
        fi
        ssh root@$NGINX_SERVER 'service nginx reload'
    else
	exit 1
    fi
}

##更新
UPDATE() {
    CHECK_PING $APP_GROUP
    TRANSPORT_PKG

    ##创建应用日志目录及日志文件
    mkdir -p ${UPDATE_LOG_DIR}
    UPDATE_LOG_FILE="${UPDATE_LOG_DIR}/update.log-${TIMESTAMPS}"
    >$UPDATE_LOG_FILE

    ##更新第2批服务器
    NGINX_OFFLINE
    echo -e "\n现在开始更新第2批服务器...\n" | tee -a $UPDATE_LOG_FILE
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "sh $UPDATE_SCRIPT deploy" | tee -a $UPDATE_LOG_FILE
}

##主函数
UPDATE
