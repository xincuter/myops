#!/bin/bash
#decription: cut log of period time only for passport...
#ver: v1.1
#auth: by zhengxin20180604
#email: hzzxin@tairanchina.com

##define source dir
SOURCE_DIR="/usr/local/weihu/passport_rest_log_analyze"

##source vars file
. ${SOURCE_DIR}/analyze_scripts/input_date.sh

##check parameters
if [ $# -lt 3 ];then
    echo "Usage: $0 {<date> <start_hour> <end_hour> [start_minute] [end_minute]}..."
    exit 1
fi

##input date
INPUT_DATE "$1"

##input time [start_hour and end_hour]
START_HOUR="$2"
END_HOUR="$3"
    
##input time [start_min and end_min]
START_MIN="$4"
END_MIN="$5"

##define DATE_TIME
DATE_TIME=$(date -d "${DATE}" +%F)

##define function of check_start_hour
CHECK_START_HOUR() {
    local i=1
    ##check start_hour
    if [ X"${START_HOUR}" != X"" ];then
        if ! echo {00..23} | grep -o "\<${START_HOUR}\>" &>/dev/null;then
            echo "please input correct hour timestamps..."
            exit 1
        fi
        ##timestamps exists in logfile or not
        while ((${START_HOUR}>=0));do
            if ! grep -E "${DATE_TIME}[[:space:]]+${START_HOUR}" $LOG_TIMESTAMPS_FILE &>/dev/null;then
                if [ "$START_HOUR" -ne 0 ];then
                    START_HOUR=$(($START_HOUR-$i))
                else
		    break
                fi
            else
		break
	    fi
        done	
    fi    
}

##define function of check_end_hour
CHECK_END_HOUR() {
    local i=1
    ##check end_hour
    if [ X"${END_HOUR}" != X"" ];then
        if ! echo {00..23} | grep -o "\<${END_HOUR}\>" &>/dev/null;then
            echo "please input correct hour timestamps..."
            exit 1
        fi
        ##timestamps exists in logfile or not
        while ((${END_HOUR}<=23));do
            if ! grep -E "${DATE_TIME}[[:space:]]+${END_HOUR}" $LOG_TIMESTAMPS_FILE &>/dev/null;then
                if [ "$END_HOUR" -ne 23 ];then
                    END_HOUR=$(($END_HOUR+$i))
                else
                    break
                fi
            else
                break
            fi
        done
    fi    
}

##define function of check_timestamps
CHECK_TIMESTAMPS() {
    ##check hour
    CHECK_START_HOUR
    CHECK_END_HOUR
    ##check minute
    if [ X"${START_MIN}" != X"" -a X"${END_MIN}" != X"" ];then 
        for i in "${START_MIN}" "${END_MIN}";do
            if ! echo {00..59} | grep -o "\<${i}\>" &>/dev/null;then
                echo "please input correct minute timestamps..."
                exit 1
            fi
        done
        START_TIME="${START_HOUR}:${START_MIN}"
        END_TIME="${END_HOUR}:${END_MIN}"
    else
        if [ X"${START_HOUR}" = X"${END_HOUR}" ];then
             START_TIME="${START_HOUR}:00"
             END_TIME="${END_HOUR}:59"
        else
             START_TIME="${START_HOUR}:00"
             END_TIME="${END_HOUR}:00"
        fi
    fi

    ##timestamps exists in logfile or not
    if ! grep -E "${DATE_TIME}[[:space:]]+${START_TIME}" $LOG_TIMESTAMPS_FILE &>/dev/null;then
         START_MIN=".*"
    fi

    if ! grep -E "${DATE_TIME}[[:space:]]+${END_TIME}" $LOG_TIMESTAMPS_FILE &>/dev/null;then
         END_MIN=".*"
    fi    

    if [ X"$START_MIN" = X".*" -a X"$END_MIN" = X".*" ];then
        echo "sorry,start_timestamps and end_timestamps aren't exist..."
        exit 1
    fi
}

##define function cut_log
CUT_LOG() {
    CHECK_TIMESTAMPS
    ##cut log and save to temp file
    LOG_START_TIME="$(date -d "${DATE} ${START_HOUR}" +%F' '%H):${START_MIN}"
    LOG_END_TIME="$(date -d "${DATE} ${END_HOUR}" +%F' '%H):${END_MIN}"
    PERIOD_ACCESS_FILE="${ACCESS_FILE}_${START_TIME/:/_}-${END_TIME/:/_}"
    
    ##cutting log based on provider timestamps   
    sed -n -r "/${LOG_START_TIME}:.+/,/${LOG_END_TIME}:.+/p" $ACCESS_FILE >$PERIOD_ACCESS_FILE      
    ##print filename
    echo $(basename $PERIOD_ACCESS_FILE)
}

##main
CUT_LOG
