#!/bin/bash
##统计访问量(uv和pv)
RECORD_ACCESS_VISITS() {
    PV=$(wc -l $1 | awk '{print $1}')
    UV=$(sed -nr "s#(.*)(sourceAddress=.*)(dstAddress.*)#\2#gp" $1 | awk -F'=' '{count[$2]++} END{for(ip in count) print count[ip],ip}' | wc -l)
    echo -e "访问量统计结果如下: \nPV: ${PV}\nUV: ${UV}"
}
