#!/bin/bash
#description: compress dubbo logs file...
#version: v1.0

##define compress function
GZIP_LOG() {
    LOG_DIR=$1
    if [ -d "$LOG_DIR" ];then
        cd $LOG_DIR
        find . -not -name "*.gz" -type f -mtime +3 | xargs -I {} gzip -9 {}
        find . -name "*.gz" -mtime +365 -delete
    fi
}

##compress log
LOG_PATH=(/var/log/dubbo)
for j in ${LOG_PATH[@]}
do
    GZIP_LOG ${j}
done
