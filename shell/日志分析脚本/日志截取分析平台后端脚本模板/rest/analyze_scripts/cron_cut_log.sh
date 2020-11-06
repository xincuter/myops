#!/bin/bash
#decription: crontab for cut rest log...
#ver: v1.0
#auth: by zhengxin20180604
#email: hzzxin@tairanchina.com

SOURCE_DIR="/usr/local/weihu/passport_rest_log_analyze"
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
    sed -n -r "/${LOG_START_TIME}:.+/,/${LOG_END_TIME}:.+/p" $ACCESS_FILE >$PERIOD_ACCESS_FILE
}

##define function of main
MAIN() {
    while (($X<=22))
    do
        START_HOUR="$X"
        END_HOUR="$(($X+$TIME_STEP))"
        X="$(($END_HOUR+$TIME_STEP))"
        START_TIME="$(printf "%02d" ${START_HOUR}):${START_MIN}"
        END_TIME="$(printf "%02d" ${END_HOUR}):${END_MIN}"
        LOG_START_TIME="$(date -d "${LOG_DATE} ${START_TIME}" +%F' '%H:%M)"
        LOG_END_TIME="$(date -d "${LOG_DATE} ${END_TIME}" +%F' '%H:%M)"
        
        ##cut log every two hours
        CRON_CUT_LOG

        X="$(($END_HOUR+$TIME_STEP))"
        sleep 2
    done
}

##compress log file
GZIP_LOG() {
    cd ${CUT_LOG_DIR}/${DATE}
    find . -not -name "catalina.out_${DATE}" -type f | xargs -I {} gzip -9 {} 
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
GZIP_LOG
CLEAN_EXPIRED_DIR
