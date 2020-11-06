#!/bin/bash
#description: 同步epel源...

DATE=$(date +%F)
START_TIME=$(date +%F_%T)
CMD=/usr/bin/rsync
LOCAL_DIR=/usr/local/epel
LOG_DIR=/var/log/epel
LOCK_FILE=${LOG_DIR}/rsync_epel.pid
BW_LIMIT=1024
LOG_FILE=${LOG_DIR}/${DATE}/rsync_epel.log
##互联网yum源url[使用国内镜像站]
YUM_URL="mirrors.ustc.edu.cn/epel/"

##指定需要同步的centos系统版本
OS_VER="6 7"
GPG_KEY="RPM-GPG-KEY-EPEL-6 RPM-GPG-KEY-EPEL-7"

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
        WRITE_LOG "epel源地址不可达，请检查网络配置或者更换其他镜像...\n"
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
    
    ##同步epel源rpm包到本地仓库
    for i in ${OS_VER};do
        if [ ! -d ${LOCAL_DIR}/${i} ];then
	    mkdir -p ${LOCAL_DIR}/${i}
	fi
        
	WRITE_LOG "现在开始同步epel${i} 源...\n" 
        rsync -arvH  --delete --bwlimit=${BW_LIMIT} --exclude="isos" --exclude="i386"  --exclude="ppc64" --exclude="aarch64" rsync://${YUM_URL}${i} ${LOCAL_DIR} >>$LOG_FILE	
	if [ $? -eq 0 ];then
	    WRITE_LOG "同步epel${i} 源成功...\n"
	else
	    WRITE_LOG "同步epel${i} 源失败...\n"
	    rm -f $LOCK_FILE
	    exit 1
        fi
    done
}

##同步gpg_key文件
RSYNC_GPG_KEY() {
    for j in ${GPG_KEY};do
        WRITE_LOG "现在开始同步gpg_key文件...\n"
	rsync -arvH  --delete --bwlimit=${BW_LIMIT} rsync://${YUM_URL}${j} ${LOCAL_DIR} >>$LOG_FILE
	if [ $? -eq 0 ];then
            WRITE_LOG "同步gpg_key文件：${j} 成功...\n"
        else
            WRITE_LOG "同步gpg_key文件：${j} 失败...\n"
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
    WRITE_LOG "正在同步网上epel源..."
    exit 1
else
    touch $LOCK_FILE
    echo $$ >$LOCK_FILE
fi

##主函数
CHECK_RSYNC
CHECK_PING
RSYNC_YUM
RSYNC_GPG_KEY


##解锁
rm -f $LOCK_FILE

##记录结束时间
END_TIME=$(date +%F_%T)
WRITE_LOG "${END_TIME}: 同步结束......"
