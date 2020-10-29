#!/bin/bash
#
#network monitor-scripts
#
#auth by zhengxin 20160420
#

#ip-list files
INTER_IP=/home/sysadmin/zhengxin/internet_address
PRE_IP=/home/sysadmin/zhengxin/online-netdevices

echo -e "\033[31m                               network monitor software\n\n                           1.online-device monitor\n\n                           2.simple-ping\n\n                           3.internet_address monitor\n\n\033[0m"

if [ -z $1 ];then
    echo "the usage is {1|2|3|4}"
    exit 2
fi

case $1 in

1)
    echo -e "\033[31mnow,online-devices monitor starting...\033[0m\n\n"
    sleep 2
    if [ ! -e $PRE_IP ];then
        echo "the file is not existing..."
    else
        if [ -f $PRE_IP ];then
            IP_NUM=`cat $PRE_IP|wc -l`
            for name in `seq 1 $IP_NUM`
            do
                HOST_IP=`sed -n "${name}p" $PRE_IP | grep -E '(\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>\.){3}\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>'`
		PING_INFO=`ping -c10 $HOST_IP`
                PACKETLOSS=`echo "$PING_INFO" | grep "packets" | awk -F, '{print $3}'|awk '{print $1}'`
                DELAY=`echo "$PING_INFO" | grep -o "min.*"`
                if [ $? -eq 0 ];then
                    echo -e "\033[32m$HOST_IP  is up\n\033[0m" 
                    echo -e "\033[32m\t\t------${PACKETLOSS}\033[0m"
                    echo -e "\033[32m\t\t------${DELAY}\n\n\033[0m"
                else
                    echo -e "\033[31m$HOST_IP  is down\n\n\033[0m"
                fi  
            done
        fi
    fi 
    ;;
2)
    echo -e "\033[31mnow,simple-ping is starting...\n\n\033[0m"
    read -p "input dest ip:" DEST
    while :
    do
        if [ $DEST == "q" -o $DEST == "quit" ];then
	    exit 7
        fi

	if [ -z $DEST ];then
            read -p "input again:" DEST
            continue
        else 
            ping -c 5 $DEST
        fi
        read -p "next ip:" DEST
    done
    ;;
3)
    echo -e "\033[31mnow,internet-address monitor is starting...\n\n\033[0m"
    sleep 2
    if [ ! -e $INTER_IP ];then
        echo "the file is not existing..."
    else
	if [ -f $INTER_IP ];then
            IP_NUM=`cat $INTER_IP|wc -l`
            for name in `seq 1 $IP_NUM`
            do
                HOST_IP=`sed -n "${name}p" $INTER_IP | grep -E '(\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>\.){3}\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>'`
		PING_INFO=`ping -c10 $HOST_IP`
                PACKETLOSS=`echo "$PING_INFO" | grep "packets" | awk -F, '{print $3}'|awk '{print $1}'`
                DELAY=`echo "$PING_INFO" | grep -o "min.*"`
                if [ $? -eq 0 ];then
                    echo -e "\033[32m$HOST_IP  is up\n\033[0m"
		    echo -e "\033[32m\t\t------${PACKETLOSS}\033[0m"
                    echo -e "\033[32m\t\t------${DELAY}\n\n\033[0m"
                else
                    echo -e "\033[31m$HOST_IP  is down\n\n\033[0m"
		    echo "$HOST_IP  is down" | mail -s "CRITICAL\t:Internet_Address Report" zhengxin@cnwisdom.com
                fi
            done
        fi
    fi
    ;;
*)
    echo "no such para..."
    ;;
esac

#echo $$
