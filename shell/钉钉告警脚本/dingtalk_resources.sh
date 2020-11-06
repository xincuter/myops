#!/bin/bash 

##define function of dingtalk notify
DING_NOTIFY(){
    URL="https://oapi.dingtalk.com/robot/send?access_token=5e492c2f773c4d2e1b532ef6d4a858b1c36819fd4db747e87ae4225a1cfc083a"    ##ͨ�ø澯�ű���ֻ���滻�˴�����Ⱥ�����˵�access_tokenֵ����
    UA="Mozilla/5.0(WindowsNT6.2;WOW64)AppleWebKit/535.24(KHTML,likeGecko)Chrome/19.0.1055.1Safari/535.24"

    RES=$(curl -XPOST -s -L -H "Content-Type:application/json" -H "charset:utf-8" $URL -d " { \"msgtype\": \"text\", \"text\":{ \"content\": \"${1}\" }, \"at\": { \"atMobiles\": [\"${2}\"], \"isAtAll\": false}}" )
    echo "$RES"  
} 

##notify
DING_NOTIFY "$1" "$2"
