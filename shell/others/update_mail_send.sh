#!/bin/bash

#read -p "please input date: " DATE

DATE=$(date -d "$1" +%F)

if [ -z "$DATE" ];then
    DATE=$(date +%F)
fi
SOURCE=/home/sysadmin/zhengxin
UPDATE_LOG_FILE=/tmp/update_app_dir/update_log_${DATE}
MAIL_FILE=$SOURCE/update_app_mail.txt
MAIL_COMMAND=/usr/sbin/sendmail


function MAIL_CONTEXT {
        echo -e "Subject: Applications_Update($DATE)\nFrom: $(hostname)\nTo: zhengxin@cnwisdom.com\nCc: tumj@cnwisdom.com\n\nDetails As Follows:\n\n$(cat $UPDATE_LOG_FILE)" >$MAIL_FILE
}

if [ -s $UPDATE_LOG_FILE ];then
    MAIL_CONTEXT
    $MAIL_COMMAND -t <$MAIL_FILE
fi    
