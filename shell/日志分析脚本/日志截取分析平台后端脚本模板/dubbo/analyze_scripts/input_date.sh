#!/bin/bash
#decription:  cut dubbo log only for passport...
#ver: v1.0
#auth: by zhengxin20180604
#email: hzzxin@tairanchina.com

DUBBO_GROUP="dubbo-beego"
LOG_ANALYSE_DIR="/usr/local/weihu/passport_dubbo_log_analyze/$DUBBO_GROUP"
LOG_DIR="/usr/local/dubbo/$DUBBO_GROUP"
HIS_LOG_DIR="/var/log/dubbo/$DUBBO_GROUP"
TEMP_DIR="${LOG_ANALYSE_DIR}/temp"
CUT_LOG_DIR="${LOG_ANALYSE_DIR}/logs"
LOG_TIMESTAMPS_FILE="$TEMP_DIR/timestamps.txt"

#create directory
mkdir -p $TEMP_DIR $CUT_LOG_DIR

##输入需要分析的日志日期,并将对应日志文件copy到日志分析目录中
INPUT_DATE() {
#    read -p "please input date: " DATE
    DATE="$1"
    TIMESTAMPS=$(date -d "$1" +%Y%m%d)
    if [ x"${DATE}" = x"$(date +%F)" ];then
        SOURCE_LOG_FILE="${LOG_DIR}/${DUBBO_GROUP/dubbo-/}.log"
    else
        SOURCE_LOG_FILE="${HIS_LOG_DIR}/${DUBBO_GROUP/dubbo-/}.${DATE}.log"
        if ls -l ${SOURCE_LOG_FILE} &>/dev/null;then
            :
        else
            if ls -l ${SOURCE_LOG_FILE}.gz &>/dev/null;then
                gzip -d ${SOURCE_LOG_FILE}.gz
            else
		echo "no such compress file..."
                exit 1
            fi        
        fi
    fi
    
    ##创建切割日志存放目录
    mkdir -p ${CUT_LOG_DIR}/${TIMESTAMPS}
    ACCESS_FILE="${CUT_LOG_DIR}/${TIMESTAMPS}/${DUBBO_GROUP}.log_${TIMESTAMPS}"
    if [ x"${DATE}" = x"$(date +%F)" ];then
        \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
    else
        if [ ! -f $ACCESS_FILE ];then
            \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
        fi
    fi
    
    ##截取日志时间戳信息并保存到文本中
    grep -E ".*\[" ${ACCESS_FILE} | awk -F'[' '{print $1}' >$LOG_TIMESTAMPS_FILE
}
