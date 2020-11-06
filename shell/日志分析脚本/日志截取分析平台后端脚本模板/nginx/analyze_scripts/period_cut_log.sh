#!/bin/bash
##截取指定时间段日志并保存到临时文件中
SOURCE_DIR="/usr/local/weihu/passport_nginx-log-analyze"

##引用脚本
. $SOURCE_DIR/analyze_scripts/input_date.sh

##定义切割日志函数
CUT_LOG() {
    ##输入日期
    INPUT_DATE "$1"

    ##input time [start_hour and end_hour]
    START_HOUR="$2"
    END_HOUR="$3"
    
    ##input time [start_min and end_min]
    START_MIN="$4"
    END_MIN="$5"    

    ##判断输入时间是否正确
    for i in "${START_HOUR}" "${END_HOUR}";do
        if ! echo {00..23} | grep -o "\<${i}\>" &>/dev/null;then
            echo "please input correct timestamps..."
            exit 1
        fi
    done

    ##check minute
    if [ x"${START_MIN}" != x"" -a x"${END_MIN}" != x"" ];then 
        for i in "${START_MIN}" "${END_MIN}";do
            if ! echo {00..59} | grep -o "\<${i}\>" &>/dev/null;then
                echo "please input correct minute timestamps..."
                exit 1
            fi
        done
        START_TIME="${START_HOUR}:${START_MIN}"
        END_TIME="${END_HOUR}:${END_MIN}"
    else
        if [ x"${START_HOUR}" = x"${END_HOUR}" ];then
             START_TIME="${START_HOUR}:00"
             END_TIME="${END_HOUR}:59"
        else
             START_TIME="${START_HOUR}:00"
             END_TIME="${END_HOUR}:00"
        fi 
    fi

    ##截取日志并保存到临时文件
    LOG_START_TIME=$(date -d "${DATE} ${START_TIME}" +%d/%b/%Y:%H:%M)
    LOG_END_TIME=$(date -d "${DATE} ${END_TIME}" +%d/%b/%Y:%H:%M)
    PERIOD_ACCESS_FILE=${ACCESS_FILE}_${START_TIME/:/_}-${END_TIME/:/_}
    awk -F '[' '$2>="'"${LOG_START_TIME}"'" && $2<="'"${LOG_END_TIME}"'"' $ACCESS_FILE >$PERIOD_ACCESS_FILE      
    ##打印切割日志文件名
    echo $(basename $PERIOD_ACCESS_FILE)
}

##切割日志
CUT_LOG "$1" "$2" "$3" "$4" "$5"
