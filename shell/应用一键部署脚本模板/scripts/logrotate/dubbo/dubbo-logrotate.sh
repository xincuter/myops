#!/bin/bash

SOURCE_DIR="/usr/local/dubbo/{{DUBBO_SERVICE}}"
LOG_FILE="{{DUBBO_LOG_FILE}}"
DATE=$(date +%F)
BACKUP_DIR="/var/log/dubbo/{{DUBBO_SERVICE}}"


mkdir -p $BACKUP_DIR

if [ -f $SOURCE_DIR/$LOG_FILE ];then
    cd $SOURCE_DIR
    cp -p $LOG_FILE $BACKUP_DIR/{{DUBBO_SERVICE}}.$DATE.log && cat /dev/null > $SOURCE_DIR/$LOG_FILE
fi

##compress dubbo-logs
find $BACKUP_DIR -name "*.log" -type f -mtime +3 | xargs -I {} gzip -9 {}
find $BACKUP_DIR -name "*.gz" -type f -mtime +120 | xargs rm -f
