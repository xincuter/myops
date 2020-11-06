#!/bin/bash
#decription:  only for passport...
#ver: v1.0
#auth: by zhengxin20180604
#email: hzzxin@tairanchina.com

LOG_ANALYSE_DIR="/usr/local/weihu/passport_rest_log_analyze"
LOG_DIR="/usr/local/tomcat/logs"
HIS_LOG_DIR="/var/log/tomcat_log"
TEMP_DIR="${LOG_ANALYSE_DIR}/temp"
CUT_LOG_DIR="${LOG_ANALYSE_DIR}/logs"
LOG_TIMESTAMPS_FILE="$TEMP_DIR/timestamps.txt"

#create directory
mkdir -p $TEMP_DIR $CUT_LOG_DIR

##输入需要分析的日志日期,并将对应日志文件copy到日志分析目录中
INPUT_DATE() {
#    read -p "please input date: " DATE
    DATE="$1"
    DATE=$(date -d "$1" +%Y%m%d)
    TIMESTAMPS="${DATE}_2359"
    if [ x"${DATE}" = x"$(date +%Y%m%d)" ];then
        SOURCE_LOG_FILE="${LOG_DIR}/catalina.out"
    else
        SOURCE_LOG_FILE="${HIS_LOG_DIR}/${TIMESTAMPS}/catalina.out"
        if ls -l ${SOURCE_LOG_FILE} &>/dev/null;then
            :
        else
            if ls -l ${HIS_LOG_DIR}/${TIMESTAMPS}.tar.gz &>/dev/null;then
		tar xf ${HIS_LOG_DIR}/${TIMESTAMPS}.tar.gz -C ${HIS_LOG_DIR}/
            fi

            if ls -l ${SOURCE_LOG_FILE}_${TIMESTAMPS}.tar.gz &>/dev/null;then
                tar xf ${SOURCE_LOG_FILE}_${TIMESTAMPS}.tar.gz -C ${HIS_LOG_DIR}/${TIMESTAMPS}
            else
		echo "no such compress file..."
                exit 1
            fi        
        fi
    fi
    
    ##创建切割日志存放目录
    mkdir -p ${CUT_LOG_DIR}/${DATE}
    ACCESS_FILE="${CUT_LOG_DIR}/${DATE}/catalina.out_${DATE}"
    if [ x"${DATE}" = x"$(date +%Y%m%d)" ];then
        \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
    else
        if [ ! -f $ACCESS_FILE ];then
            \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
        fi
    fi

    ##截取日志时间戳信息并保存到文本中
    grep -E ".*\[" ${ACCESS_FILE} | awk -F'[' '{print $1}' >$LOG_TIMESTAMPS_FILE
}
