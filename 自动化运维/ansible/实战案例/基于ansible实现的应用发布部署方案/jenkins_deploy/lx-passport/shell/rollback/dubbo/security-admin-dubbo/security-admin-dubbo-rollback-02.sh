#!/bin/bash
#description: dubbo应用一键回滚脚本...
#version: V1.1
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##define variables
PROJ_NAME="security-admin-dubbo"
ANSIBLE_CMD="/usr/bin/ansible"
APP_GROUP="prd-lx-passport_security-admin-dubbo-part02"
UPDATE_SCRIPT="/usr/local/weihu/lx-passport-update_${PROJ_NAME}.sh"
ROLLBACK_LOG_DIR="/jenkins_deploy/lx-passport/logs/rollback/$PROJ_NAME/part02"
TIMESTAMPS=$(date +%Y%m%d%H%M)


##ping检测
CHECK_PING() {
    $ANSIBLE_CMD "$1" -m ping &>/dev/null
    if [ $? -ne 0 ];then
	echo "$1 ping is failed,please check..."
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

    ##回滚第2批服务器
    echo -e "\n现在开始回滚第2批服务器...\n" | tee -a $ROLLBACK_LOG_FILE
    $ANSIBLE_CMD "$APP_GROUP" -m shell -a "sh $UPDATE_SCRIPT rollback $ROLLBACK_POINT" | tee -a $ROLLBACK_LOG_FILE
}

##主函数
ROLLBACK "$1"
