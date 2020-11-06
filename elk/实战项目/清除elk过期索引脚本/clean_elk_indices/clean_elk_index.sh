#!/bin/bash
#description: 清理过期elk索引(默认只清理60天之前的)...
#auth: by XinZheng
#version: v1.0
#email: hzzxin@tairanchina.com

DATE=$(date +%F)
BUSINESS_GROUP_LIST=(passport)
SOURCE_ROOT="/usr/local/weihu/clean_elk_indices"
INDEX_FILE="${SOURCE_ROOT}/indicies.txt"
EXPIRED_INDEX_FILE="${SOURCE_ROOT}/expired_indicies_date.txt"
LOG_DIR="${SOURCE_ROOT}/logs"
LOG_FILE="${LOG_DIR}/clean_elk_index.log-${DATE}"

##创建目录及文件
mkdir -p $LOG_DIR
>$LOG_FILE

##记录日志
record_log() {
    echo -e "$1""\n" >>${LOG_FILE}
}

##获取业务相关elk日志索引,并保存至文件中
record_indeices() {
    ##截取指定业务elk索引
    INDEX_INFO="$(curl -XGET "http://127.0.0.1:9200/_cat/indices/${1}-*" 2>/dev/null)"
    echo "$INDEX_INFO" | awk '{print $3}' >${INDEX_FILE}
}

##筛选出过期的索引,并保存至文件中
record_expired_indeices() {
    ##筛选过期时间戳的elk索引
    DATE_PERIOD="60"
    EXPIRED_DATE_INFO="$(awk -F"-" '{print $NF}' ${INDEX_FILE} | sort -u | sort -rn | sed -n "$(($DATE_PERIOD+1)),\$p")"
    if [ x"$EXPIRED_DATE_INFO" = x"" ];then
        echo "no expired indices need to clean..."
        exit 1
    else
        echo "$EXPIRED_DATE_INFO" >${EXPIRED_INDEX_FILE}
    fi
}

##清除过期的索引
delete_expired_indeices() {
    record_expired_indeices
    record_log "now,start clean expired indices: \n"
    for index_date in $(cat ${EXPIRED_INDEX_FILE})
    do
        record_log "${index_date} indices list as follow: " 
        record_log "$(grep "${index_date}" ${INDEX_FILE})"
        
        ##删除索引
        curl -s -XDELETE "http://127.0.0.1:9200/${1}-*-${index_date}" &>/dev/null
    done
}

##主程序
for i in "${BUSINESS_GROUP_LIST[@]}"
do
    record_indeice ${i}
    delete_expired_indeices ${i}
done
