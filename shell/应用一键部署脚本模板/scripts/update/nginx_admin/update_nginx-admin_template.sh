#!/bin/bash
##description: 生产环境nginx端管理后台应用一键更新脚本模板...
#version: V1.0
#auth: by zhengxin20180619
#email: hzzxin@tairanchina.com

DATE=$(date +%Y%m%d%H%M)
SOURCE=/data
PKG_SOURCE=$SOURCE/deploy
BACKUP_SOURCE=$SOURCE/backup
UPDATE_SOURCE=$SOURCE/update
TEMP_DIR=$UPDATE_SOURCE/pkg/nginx_admin_tmp
APP_SOURCE=/usr/local/nginx/html-admin
PKG_PATH_FILE=${TEMP_DIR}/pkg.txt
LOCK_FILE=/tmp/nginx_admin.lock
USER=myweb
GROUP=myweb


##创建deploy,backup,update目录
mkdir -p ${PKG_SOURCE} ${BACKUP_SOURCE} ${UPDATE_SOURCE}
mkdir -p $TEMP_DIR
>$PKG_PATH_FILE

##创建应用运行主目录（若无）
[ -d $APP_SOURCE ] || mkdir -p $APP_SOURCE

##加锁
SHELL_LOCK() {
    if [ -e $LOCK_FILE ];then
        echo "lock has been exists,can't operate this script on multiuser-mode..."
        exit 1
    else
        touch $LOCK_FILE
        echo $$ >$LOCK_FILE
    fi
}

##解锁
SHELL_UNLOCK() {
    rm -f $LOCK_FILE
}


##记录更新包路径到文件中
RECORD_PKG_PATH() {
    ##record pkg path to file
    ls -1 ${TEMP_DIR} | grep -v ".*\.txt" >$PKG_PATH_FILE   

    ##检测应用列表是否为空
    if [ ! -s $PKG_PATH_FILE ];then
        echo "应用列表为空..."
        SHELL_UNLOCK
        exit 1
    fi
}

##检测文件
CHECK_FILE() {
    if [ x"$1" = x"" ];then
        echo "包名不能为空..."
        SHELL_UNLOCK
        exit 1
    fi

    if echo $1 | grep "\.zip" &>/dev/null;then
        if file ${TEMP_DIR}/$1 | grep -io "Zip archive data" &>/dev/null;then
            :
        else
            echo "包文件格式不是zip格式..."
            SHELL_UNLOCK
            exit 1
        fi
    else
        echo "不是zip包..."
        SHELL_UNLOCK
        exit 1
    fi
}


##获取应用名称(APP_NAME)
GET_APP_NAME() {
    APP_NAME=$(echo ${1} | sed -r "s#(.*)(\.zip.*)#\1#g")
}


##检测tag版本
CHECK_TAG_VER() {
    TAG_VERSION=$(echo ${1/*.zip-/})
    if [ x"$TAG_VERSION" = x"" ];then
        echo "${APP_NAME}: 应用tag标记不能为空..."
        SHELL_UNLOCK 
        exit 1
    else
        if ! echo $TAG_VERSION | grep -E "^[[:digit:]]+$" &>/dev/null;then
            echo "${APP_NAME}: tag标记格式不对..."
            SHELL_UNLOCK
            exit 1
        fi
    fi

    if ls -1 ${PKG_SOURCE}/${APP_NAME} | grep "^${TAG_VERSION}$" &>/dev/null;then
        echo "${APP_NAME}: 该版本已更新，不能重复更新..."
        SHELL_UNLOCK
        exit 1
    fi        
}

##备份应用更新包
BACKUP_PKG() {
    if [ ! -d ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION} ];then
        mkdir -p ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}
    fi
    mv ${TEMP_DIR}/$1 ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}/
}


##更新前备份当前版本
BACKUP() {
    if [ ! -d ${BACKUP_SOURCE}/${APP_NAME}/${TAG_VERSION} ];then
         mkdir -p ${BACKUP_SOURCE}/${APP_NAME}/${TAG_VERSION}
    fi

    if [ -d ${APP_SOURCE}/${APP_NAME} ];then
        \cp -a  ${APP_SOURCE}/${APP_NAME}/* ${BACKUP_SOURCE}/${APP_NAME}/${TAG_VERSION}
    fi
}


##更新应用
UPDATE() {
    echo "now,${APP_NAME} update is starting: "
    sleep 2
    cd ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}
    unzip ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}/$1 -d .
    if [ $? -eq 0 ];then
        echo "解压成功..."
    else
        echo "解压失败，请检测更新包..."
        SHELL_UNLOCK
        exit 1
    fi
    
    if [ ! -d ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}/${APP_NAME} ];then
        echo "更新包没有顶层目录..."
        SHELL_UNLOCK
        exit 1
    fi

    rm -rf ${APP_SOURCE}/${APP_NAME}
    ln -sf ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}/${APP_NAME} ${APP_SOURCE}/${APP_NAME}       
    
    ##清除过期版本(默认每个项目工程最多保留6个历史版本)
    CURRENT_TAG=$(ls -l ${APP_SOURCE}/${APP_NAME} | awk '{print $NF}' | sed -nr "s#(.*[0-9]+)(/.*)#\1#gp")
    if [ x"$CURRENT_TAG" != x"" ];then
        EXPIRED_TAG=$(ls -1rd ${PKG_SOURCE}/${APP_NAME}/[1-9]* | grep -v "${CURRENT_TAG}" | sed -n "6,\$p")
        rm -rf $EXPIRED_TAG
    fi
}

##更改应用目录属主属组
CHANGE_OWNER() {
    chown -R ${USER}:${GROUP} ${APP_SOURCE} ${PKG_SOURCE}    
}


##部署
DEPLOY() {
    RECORD_PKG_PATH

    for i in $(cat $PKG_PATH_FILE);do
        CHECK_FILE ${i}
        GET_APP_NAME ${i}
        CHECK_TAG_VER ${i}
        BACKUP_PKG ${i}
        BACKUP
        UPDATE ${i}    
    done
    
    CHANGE_OWNER
}

##列出最近的几个版本
LIST_VER() {
    APP_NAME="$1"

    if [ x"$APP_NAME" = x"" ];then
        echo "you need to provide 1 parameter: [for example: list <app_name>]..."
        exit 1
    fi

    ##列出应用当前版本
    if ls -l ${APP_SOURCE}/${APP_NAME} &>/dev/null;then
        CURRENT_VER=$(ls -l ${APP_SOURCE}/${APP_NAME} | awk '{print $NF}')
        echo -e "${APP_NAME} 当前版本如下: "
        echo -e "${CURRENT_VER}\n"
    else
        echo "${APP_NAME} 不存在..."
        SHELL_UNLOCK
        exit 1
    fi

    if ! ls -1d ${PKG_SOURCE}/${APP_NAME}/[1-9]*/${APP_NAME} &>/dev/null;then
        echo "${APP_NAME} 没有最近版本......"
        SHELL_UNLOCK
        exit 1
    else
        LAST_VER=$(ls -1dr ${PKG_SOURCE}/${APP_NAME}/[1-9]*/${APP_NAME} | grep -v "$CURRENT_VER")
        echo -e "${APP_NAME} 最近版本如下: "
        echo -e "${LAST_VER}\n"
    fi            
}

##回滚到指定版本
ROLLBACK() {
    APP_NAME="$1"
    LIST_VER $APP_NAME &>/dev/null
    ROLLBACK_POINT="$2"
    
    if [ x"$APP_NAME" = x"" -o x"$ROLLBACK_POINT" = x"" ];then
        echo "you need to provide 2 parameters: [for example: rollback <app_name> <rollback_point>]..."
        SHELL_UNLOCK
        exit 1
    fi

    if ! echo "$LAST_VER" | grep "$ROLLBACK_POINT" &>/dev/null;then
        echo "${APP_NAME}: rollback point not exists..."
        SHELL_UNLOCK
        exit 1
    else
        echo "now,starting rollback ${APP_NAME}..."
        sleep 2
        rm -f ${APP_SOURCE}/${APP_NAME}
        ln -sf $ROLLBACK_POINT ${APP_SOURCE}/${APP_NAME}
    fi   

    CHANGE_OWNER
}


##主程序
SHELL_LOCK

case $1 in
deploy)
    DEPLOY
    ##清空临时目录
    rm -rf $TEMP_DIR/*
    ;;
list)
    LIST_VER $2
    ;;
rollback)
    ROLLBACK $2 $3 
    ;;
*)
    echo "Usage: $0  {deploy | list | rollback}..."
    exit 1
    ;;
esac

##解锁
SHELL_UNLOCK
