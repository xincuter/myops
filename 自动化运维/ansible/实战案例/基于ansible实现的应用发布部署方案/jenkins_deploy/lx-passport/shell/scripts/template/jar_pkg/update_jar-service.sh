#!/bin/bash
##description: 生产环境jar包应用一键部署脚本模板...
##version: v1.0
##auth: by zhengxin20180620
##email: hzzxin@tairanchina.com

SOURCE="/data"
APP_NAME="account-sync-service"
PROJ_NAME="${APP_NAME}.jar"
LOG_FILE="${APP_NAME}.out"
PKG_SOURCE="$SOURCE/deploy"
BACKUP_SOURCE="$SOURCE/backup"
UPDATE_SOURCE="$SOURCE/update"
TEMP_DIR="$UPDATE_SOURCE/pkg/${APP_NAME}_tmp"
APP_SOURCE="/usr/local/${APP_NAME}"
PKG_PATH_FILE="${TEMP_DIR}/${APP_NAME}.txt"
LOCK_FILE="/tmp/${APP_NAME}.lock"
START_CMD="$(which java)"
HEAP_MEM="4096m"
LIS_PORT="8090"
CHECK_URL="http://127.0.0.1:${LIS_PORT}/account/sync/push"

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
    ##记录包名到文件中
    ls -1 ${TEMP_DIR}/ | grep -o "${PROJ_NAME}-.*" >$PKG_PATH_FILE   

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

    if ! echo "$1" | grep "\<$PROJ_NAME\>" &>/dev/null;then
        echo "更新包与项目名不匹配..."
        SHELL_UNLOCK
        exit 1
    fi

    if [ -f ${TEMP_DIR}/$1 ];then
        if [ ! -s ${TEMP_DIR}/$1 ];then
            echo "包大小错误，请检查..."
            SHELL_UNLOCK
            exit 1
        fi
    else
        echo "包不存在..."
        SHELL_UNLOCK
        exit 1
    fi
 
    if echo $1 | grep "\.jar" &>/dev/null;then
        :
    else
        echo "不是jar包..."
        SHELL_UNLOCK
        exit 1
    fi
}

##检测tag版本
CHECK_TAG_VER() {
    TAG_VERSION=$(echo ${1/*.jar-/})
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

    if [ -f ${APP_SOURCE}/$PROJ_NAME ];then
        \cp -a  ${APP_SOURCE}/${APP_NAME}* ${BACKUP_SOURCE}/${APP_NAME}/${TAG_VERSION}
    fi
}

##kill进程
KILL_PROCESS() {
    if [ $(ps -ef | grep \[j]ava | grep "${PROJ_NAME}" | grep -v "grep" | wc -l) -gt 0 ];then
        PID=$(ps -ef | grep \[j]ava | grep "${PROJ_NAME}" | grep -v "grep" | awk '{print $2}')
        kill -9 "$PID"
    fi
}

##检测服务
CHECK_SERVICE() {
    sleep 5
    while((x<=10))
    do
        RETURN_CODE=$(curl -XPOST -I -m 5 --retry 3 --connect-timeout 5 -o /dev/null -s -w %{http_code} $CHECK_URL)
        if [ x"$RETURN_CODE" = x"200" -o x"$RETURN_CODE" = x"302" -o x"$RETURN_CODE" = x"415" ];then
            echo -e  "${APP_NAME}: the ${x} check is successful..."
            break
        else
            echo -e  "${APP_NAME}: the ${x} check is failed..."
        fi
        let x++
        sleep 5
    done
}

##更新应用
UPDATE() {
    echo "now,${APP_NAME} update is starting: "
    sleep 2
    KILL_PROCESS
    rm -rf ${APP_SOURCE}/${PROJ_NAME}
    ln -svf  ${PKG_SOURCE}/${APP_NAME}/${TAG_VERSION}/$1 ${APP_SOURCE}/${PROJ_NAME}
    echo "now starting ${APP_NAME}..."
    cd $APP_SOURCE
    nohup ${START_CMD} -Xms${HEAP_MEM} -Xmx${HEAP_MEM} -server -jar ${APP_SOURCE}/${PROJ_NAME} --spring.profiles.active=prd --server.port=${LIS_PORT} >>${APP_SOURCE}/$LOG_FILE &
    CHECK_SERVICE
}


##部署
DEPLOY() {
    RECORD_PKG_PATH

    for i in $(cat $PKG_PATH_FILE)
    do
        CHECK_FILE ${i}
        CHECK_TAG_VER ${i}
        BACKUP_PKG ${i}
        BACKUP
        UPDATE ${i}
    done
}

##列出最近版本
LIST_VER() {
    ##列出当前应用版本
    CURRENT_VER=$(ls -l ${APP_SOURCE}/${PROJ_NAME} | awk '{print $NF}')

    echo -e "当前版本如下:  "
    echo -e "${CURRENT_VER}\n" 

    if ! ls -1 ${PKG_SOURCE}/${APP_NAME} &>/dev/null;then
         echo "该应用没有最近版本..."
         SHELL_UNLOCK
         exit 1
    else
         LAST_VER=$(ls -1r ${PKG_SOURCE}/${APP_NAME}/*/${PROJ_NAME}* | grep -v "$CURRENT_VER")
         echo -e "最近的版本如下: "
         echo -e "${LAST_VER}\n"
    fi            
}

##回滚
ROLLBACK() {
    LIST_VER &>/dev/null
    ROLLBACK_POINT="$1"
    
    if [ -z $ROLLBACK_POINT ];then
         echo "缺少第二个参数: 回滚点"
         SHELL_UNLOCK
         exit 1
    fi

    if ! echo "$LAST_VER" | grep "$ROLLBACK_POINT" &>/dev/null;then
         echo "对不起，您所指定的版本不存在..."
         SHELL_UNLOCK
         exit 1
    else
         echo "[${APP_NAME}]开始回滚到[${ROLLBACK_POINT}]版本: "
         KILL_PROCESS
         sleep 5
         rm -rf ${APP_SOURCE}/${PROJ_NAME}
         ln -svf $ROLLBACK_POINT ${APP_SOURCE}/${PROJ_NAME}
         cd $APP_SOURCE
         nohup ${START_CMD} -Xms${HEAP_MEM} -Xmx${HEAP_MEM} -server -jar ${APP_SOURCE}/$PROJ_NAME --spring.profiles.active=prd --server.port=${LIS_PORT} >>${APP_SOURCE}/$LOG_FILE &
    fi

    ##检测服务正常性
    CHECK_SERVICE  
}

##主程序
SHELL_LOCK

case $1 in
deploy)
    DEPLOY
    ;;
list)
    LIST_VER
    ;;
rollback)
    ROLLBACK $2
    ;;
*)
    echo "Usage: $0  { deploy | list | rollback <rollback_point> }..."
    SHELL_UNLOCK
    exit 1
    ;;
esac

#清空缓存目录
rm -rf ${TEMP_DIR}/*

##解锁
SHELL_UNLOCK
