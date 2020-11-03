#!/bin/bash
#description: compress tomcat logs file...
#version: v1.0

##define compress function
GZIP_LOG() {
    LOG_DIR=$1
    if [ -d "$LOG_DIR" ];then
        cd $LOG_DIR
        find . -not -name "*.gz" -name "catalina.out.[[:digit:]]*" -type f -mtime +3 | xargs -I {} gzip -9 {}
        find . -not -name "*.gz" -name "localhost_access_log*.txt" -type f -mtime +3 | xargs -I {} gzip -9 {}
        find . -not -name "*.gz" -name "*[[:digit:]]*.log" -not -size 0k -type f -mtime +3 |  xargs -I {} gzip -9 {}
        find . -name "*.gz" -mtime +180 -delete
    fi
}

##compress log
LOG_PATH=(/usr/local/tomcat/logs)
for j in ${LOG_PATH[@]}
do
    GZIP_LOG ${j}
done
