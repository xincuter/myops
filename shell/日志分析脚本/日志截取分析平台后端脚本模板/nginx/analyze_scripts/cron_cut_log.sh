#!/bin/bash
#decription: crontab for cut nginx log...
#ver: v1.0
#auth: by zhengxin20180604
#email: hzzxin@tairanchina.com

SOURCE_DIR="/usr/local/weihu/passport_nginx-log-analyze"
X="0"
TIME_STEP="1"
START_MIN="00"
END_MIN="59"

##check date
LOG_DATE="$1"
if [ x"$LOG_DATE" = x"" ];then
    LOG_DATE="$(date -d "1 day ago" +%F)"
fi

##source vars file
. ${SOURCE_DIR}/analyze_scripts/input_date.sh

##get source log file
INPUT_DATE "${LOG_DATE}"

##define function of cron_cut_log
CRON_CUT_LOG() {
    PERIOD_ACCESS_FILE="${ACCESS_FILE}_${START_TIME/:/_}-${END_TIME/:/_}"
    if grep -o "${LOG_START_TIME}" ${ACCESS_FILE} &>/dev/null;then
	if grep -o "${LOG_END_TIME}" ${ACCESS_FILE} &>/dev/null;then
            :
        else
            echo "timestamps: ${LOG_END_TIME} is not exists..."
            #exit 1
        fi
    else
        echo "timestamps: ${LOG_START_TIME} is not exists..."
        #exit 1
    fi
    
    ##cutting log based on provider timestamps   
    awk -F '[' '$2>="'"${LOG_START_TIME}"'" && $2<="'"${LOG_END_TIME}"'"' $ACCESS_FILE >$PERIOD_ACCESS_FILE
}

##define function of main
MAIN() {
    while (($X<=23))
    do
        START_HOUR="$X"
        END_HOUR="$X"
        X="$(($END_HOUR+$TIME_STEP))"
        START_TIME="$(printf "%02d" ${START_HOUR}):${START_MIN}"
        END_TIME="$(printf "%02d" ${END_HOUR}):${END_MIN}"
        LOG_START_TIME="$(date -d "${LOG_DATE} ${START_TIME}" +%d/%b/%Y:%H:%M:%S)"
        LOG_END_TIME="$(date -d "${LOG_DATE} ${END_TIME}:59" +%d/%b/%Y:%H:%M:%S)"
        
        ##cut log every two hours
        CRON_CUT_LOG

        X="$(($END_HOUR+$TIME_STEP))"
        sleep 2
    done
}

##clean expired log
CLEAN_EXPIRED_DIR() {
    cd ${CUT_LOG_DIR}
    EXPIRED_DIR="$(ls -1 . | sort -r -n | sed -n "5,\$p")"
    if [ ! -z "$EXPIRED_DIR" ];then
        mv $EXPIRED_DIR ${TEMP_DIR}/
        rm -rf ${TEMP_DIR}/*
    fi
}

##main
MAIN
sleep 10
CLEAN_EXPIRED_DIR
