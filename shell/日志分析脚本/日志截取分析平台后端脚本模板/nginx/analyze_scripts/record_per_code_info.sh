#!/bin/bash
##统计每种http code请求对应的最大10个url接口
RECORD_PER_CODE_INFO() {
    echo -e "每种http code请求日志详情: "
    for i in $(cat $ACCESS_CODE_FILE);do
        grep "responseCode=${i}" $1 >$PER_CODE_ACCESS_FILE
        PER_CODE_IP_INFO=$(sed -nr "s#(.*)(sourceAddress=.*)(dstAddress.*)#\2#gp" $PER_CODE_ACCESS_FILE | awk -F'=' '{count[$2]++} END{for(ip in count) print count[ip],ip}' | sort -rn -k 1 | head -10)
        PER_CODE_URL_INFO=$(grep -o "requestRInfo.*" $PER_CODE_ACCESS_FILE | awk '{count[$2]++} END{for(url in count) print count[url],url}' | sort -rn -k 1 | head -10)
        echo -e "------------------- http_code(${i}) 日志分析结果如下 -------------------"
        echo -e "请求状态码为${i},top 10 ip: "
	echo -e "$PER_CODE_IP_INFO" | column -t
        echo -e "请求状态码为${i},top 10 url: "
        echo -e "$PER_CODE_URL_INFO" | column -t
        echo
    done        
}

