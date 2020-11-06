#!/bin/bash
##统计并显示访问量最大的前20个ip
RECORD_IP() {
    ACCESS_INFO=$(sed -nr "s#(.*)(sourceAddress=.*)(dstAddress.*)#\2#gp" $1 | awk -F'=' '{count[$2]++} END{for(ip in count) print count[ip],ip}' | grep -vE "10\.203\.0\.2|192\.168\..*|10\.207\..*" | sort -rn -k 1 | head -20)

    ##将截取出来的ip保存到文件中
    echo "$ACCESS_INFO" | awk '{print $NF}' >$ACCESS_IP_FILE
    echo -e "ip_address top 20: "
    echo "$ACCESS_INFO" | column -t       
}
