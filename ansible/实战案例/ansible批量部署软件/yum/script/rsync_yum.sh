#!/bin/bash
#description: 同步互联网yum仓库...

DATE=$(date +%F)
START_TIME=$(date +%F_%T)
CMD=/usr/bin/rsync
LOCAL_DIR=/usr/local/yum_repo
LOG_DIR=/var/log/rsync_yum
LOCK_FILE=${LOG_DIR}/rsync_yum.pid
BW_LIMIT=1024
LOG_FILE=${LOG_DIR}/${DATE}/rsync_yum.log
##互联网yum源url[使用国内镜像站]
#YUM_URL="mirrors.aliyun.com/centos/"
YUM_URL="mirrors.kernel.org/centos/"

##指定需要同步的centos系统版本
OS_VER="6 6* 7 7*"

##检测rsync是否安装
CHECK_RSYNC() {
    if ! which $CMD &>/dev/null;then
	yum install rsync -y &>/dev/null
	if [ $? -ne 0 ];then
	    WRITE_LOG "安装rsync失败...\n"
	    exit 1
	fi
    fi
}

##检测本机到网上yum源地址网络是否可达
CHECK_PING() {
    CURL_CODE=$(curl -I -m 5 --retry 3 --connect-timeout 5 -o /dev/null -s -w %{http_code} $YUM_URL)       
    if [ x"$CURL_CODE" = x"200" ];then
	:
    else
        WRITE_LOG "网上yum源地址不可达，请检查网络配置或者更换其他镜像...\n"
    fi
}


##保存同步日志到文件
WRITE_LOG() {
    echo $1 >>$LOG_FILE
}

##同步网上yum源
RSYNC_YUM() {
    if [ ! -d $LOCAL_DIR ];then
	mkdir -p $LOCAL_DIR
    fi    
    
    ##同步各个系统版本的rpm包到本地仓库
    for i in ${OS_VER};do
        if [ ! -d ${LOCAL_DIR}/${i} ];then
	    mkdir -p ${LOCAL_DIR}/${i}
	fi
        
	WRITE_LOG "现在开始同步centos${i} yum源...\n"
        rsync -arvH  --delete --bwlimit=${BW_LIMIT} --exclude="isos" rsync://${YUM_URL}${i} ${LOCAL_DIR} >>$LOG_FILE	
	if [ $? -eq 0 ];then
	    WRITE_LOG "同步centos${i} yum源成功...\n"
	else
	    WRITE_LOG "同步centos${i} yum源失败...\n"
	    rm -f $LOCK_FILE
	    exit 1
        fi
    done
}


##检测目录是否创建
if [ ! -d ${LOG_DIR}/${DATE} ];then
    mkdir -p ${LOG_DIR}/${DATE}
fi

##记录同步开始时间
WRITE_LOG "${START_TIME}: 同步开始......"

##执行脚本加锁
if [ -e $LOCK_FILE ];then
    WRITE_LOG "正在同步网上yum源..."
    exit 1
else
    touch $LOCK_FILE
    echo $$ >$LOCK_FILE
fi

##主函数
CHECK_RSYNC
CHECK_PING
RSYNC_YUM


##解锁
rm -f $LOCK_FILE

##记录结束时间
END_TIME=$(date +%F_%T)
WRITE_LOG "${END_TIME}: 同步结束......"
