#!/bin/bash
#description: tomcat-rest应用一键回滚脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##define variables
PROJ_NAME="account#validate"
ANSIBLE_CMD="/usr/bin/ansible"
APP_GROUP="prd-lx-passport_tomcat-rest-part01"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_rest-${PROJ_NAME}.sh"
NGINX_CONF_DIR="/jenkins_deploy/lx-passport/nginx"
UPSTREAM_FILE="${NGINX_CONF_DIR}/upstream_passrest.conf-part01"
NGINX_SERVER="10.206.188.23"
ROLLBACK_LOG_DIR="/jenkins_deploy/lx-passport/logs/rollback/$PROJ_NAME/part01"
TIMESTAMPS=$(date +%Y%m%d%H%M)


##ping检测
CHECK_PING() {
    $ANSIBLE_CMD "$1" -m ping &>/dev/null
    if [ $? -ne 0 ];then
	echo "$1 ping is failed,please check..."
	exit 1
    fi
}

##nginx下线第1批passrest服务,上线第2批passrest服务
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

##回滚
ROLLBACK() {
    CHECK_PING $APP_GROUP

    ##创建应用日志目录及日志文件
    mkdir -p ${ROLLBACK_LOG_DIR}
    ROLLBACK_LOG_FILE="${ROLLBACK_LOG_DIR}/rollback.log-${TIMESTAMPS}"
    >$ROLLBACK_LOG_FILE

    ##判断传递回滚点参数是否为空
    ROLLBACK_POINT="$1"
    if [ x"$ROLLBACK_POINT" = x"" ];then
        echo "sorry,please provide <rollback_point>..."
        exit 1
    fi

    ##回滚第1批服务器
    NGINX_OFFLINE
    echo -e "\n现在开始回滚第1批服务器...\n" | tee -a $ROLLBACK_LOG_FILE
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "sh $UPDATE_SCRIPT rollback $ROLLBACK_POINT" | tee -a $ROLLBACK_LOG_FILE
}

##主函数
ROLLBACK "$1"
