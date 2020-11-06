#!/bin/bash
##统计并显示访问量最大的前20个url
RECORD_URL() {
    URL_INFO=$(grep -o "requestRInfo.*" $1 | awk '{count[$2]++} END{for(url in count) print count[url],url}' | sort -rn -k 1 | head -20)
 
    ##将截取出来的url保存到文件中
    echo "$URL_INFO" | awk '{print $NF}' >$ACCESS_URL_FILE   
    echo -e "url top 20: "
    echo "$URL_INFO" | column -t
}
