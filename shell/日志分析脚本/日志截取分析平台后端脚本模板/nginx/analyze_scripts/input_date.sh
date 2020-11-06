#!/bin/bash
NGINX_LOG_DIR="/usr/local/nginx/logs"
NGINX_HIS_LOG_DIR="/var/log/nginx_log"
LOG_ANALYSE_DIR="/usr/local/weihu/passport_nginx-log-analyze"
TEMP_DIR="${LOG_ANALYSE_DIR}/temp"
CUT_LOG_DIR="${LOG_ANALYSE_DIR}/logs"
ACCESS_IP_FILE="${TEMP_DIR}/ip_file"
ACCESS_URL_FILE="${TEMP_DIR}/url_file"
ACCESS_CODE_FILE="${TEMP_DIR}/code_file"
PER_IP_ACCESS_FILE="${TEMP_DIR}/per_access_file"
PER_CODE_ACCESS_FILE="${TEMP_DIR}/per_code_access_file"

##create directory
mkdir -p $TEMP_DIR

##输入需要分析的日志日期,并将对应日志文件copy到日志分析目录中
INPUT_DATE() {
#   read -p "please input date: " DATE
    DATE="$1"
    if [ x"${DATE}" = x"$(date +%F)" ];then
        SOURCE_LOG_FILE="${NGINX_LOG_DIR}/pass_80.access.log"
    else
        SOURCE_LOG_FILE="${NGINX_HIS_LOG_DIR}/${DATE}/${DATE}-pass_80.access.log"
        if ls -l ${SOURCE_LOG_FILE}.gz &>/dev/null;then
            gzip -d ${SOURCE_LOG_FILE}.gz
        else
            if ! ls -l ${SOURCE_LOG_FILE} &>/dev/null;then
                echo "no such log file..."
                exit 1
            fi
        fi
    fi
    
    ##创建切割日志存放目录
    mkdir -p ${CUT_LOG_DIR}/${DATE}
    ACCESS_FILE="${CUT_LOG_DIR}/${DATE}/access_file_${DATE}"
    if [ x"${DATE}" = x"$(date +%F)" ];then
        \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
    else
        if [ ! -f $ACCESS_FILE ];then
            \cp -a ${SOURCE_LOG_FILE} ${ACCESS_FILE}
        fi
    fi
}

