#!/bin/bash
##统计并显示每个ip访问详细情况(ip_address top 20)
RECORD_PER_IP_INFO (){
    echo -e "top 20 ip的访问日志详情: "
    for j in $(cat $ACCESS_IP_FILE);do
        grep "sourceAddress=${j}" $1 >$PER_IP_ACCESS_FILE
        PER_URL_INFO=$(grep -o "requestRInfo.*" $PER_IP_ACCESS_FILE | awk '{count[$2]++} END{for(url in count) print count[url],url}' | sort -rn -k 1 | head -10)
        PER_CODE_INFO=$(grep -oE "responseCode=[0-5]{3}" $PER_IP_ACCESS_FILE | awk -F'=' '{count[$2]++} END{for(code in count) print count[code],code}' | sort -rn -k 1)
        PER_REQUEST_METHOD_INFO=$(grep -o "requestRInfo.*" $PER_IP_ACCESS_FILE | awk -F'[=" ]+' '{count[$2]++} END{for(request_method in count) print count[request_method],request_method}' | sort -rn -k 1)
        echo -e "--------------- ${j} 访问日志分析结果如下 ------------------"
	echo -e "访问url top 10: "
        echo -e "${PER_URL_INFO}" | column -t
        echo -e "http请求方法统计: "
        echo -e "${PER_REQUEST_METHOD_INFO}" | column -t
        echo -e "http请求状态码统计: "
        echo -e "${PER_CODE_INFO}" | column -t
        sleep 1
        echo
    done
}   
