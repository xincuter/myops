#!/bin/bash
##统计并显示http请求状态码信息
RECORD_HTTP_CODE() {
    CODE_INFO=$(grep -oE "responseCode=[0-5]{3}" $1 | awk -F'=' '{count[$2]++} END{for(code in count) print count[code],code}' | sort -rn -k 1)
    
    ##将截取出来的http code保存到文件中
    echo "$CODE_INFO" | awk '{print $NF}' >$ACCESS_CODE_FILE
    echo -e "http code info: "
    echo "$CODE_INFO" | column -t
}
