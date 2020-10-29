#!/bin/bash
#script-name: mkservice_ports.sh
#description:
##The script is in order to get the listen ports of tcp from remote-servers,then make two files...
#auth:  by  zhengxin    email: zhengxin@cnwisdom.com

MONITOR_OBJ=/home/sysadmin/zhengxin/iplist
OBJ_NUM=`cat $MONITOR_OBJ | wc -l`
NAGIOS_SERVER=192.168.2.116

if [ ! -e $MONITOR_OBJ ];then
        echo "no such file,please checking..."
        exit 1
else
        if [ -z "`cat $MONITOR_OBJ`" ];then
                echo "the file is empty..."
                exit 2
        fi
fi


for name in `seq 1 $OBJ_NUM`
do
    OBJ_IP=`sed -n "${name}p" $MONITOR_OBJ`
    if ! ping -c3  $OBJ_IP &>/dev/null;then
        echo "the host is unreachable..."
        continue
    else
        SERVICE_LIST=$(ssh root@${OBJ_IP} netstat -lntp | grep -Ev "snmpd|sshd|master|ntpd|cupsd" | grep -v "\<::1\>" | awk '$1~/^tcp/{print $4,$7}' | column -t)
	PORT_LIST=$(echo "$SERVICE_LIST" | awk '{print $1}' | sed 's#^.*:##g')
        NAME_LIST=$(echo "$SERVICE_LIST" | awk '{print $2}' | sed 's#.*/##g')
	SERVICE_NUM=$(echo "$SERVICE_LIST" | wc -l)
        for i in `seq 1 $SERVICE_NUM`
        do
            SERVICE_PORT=$(echo "$PORT_LIST" | sed -n "${i}p")
            echo $SERVICE_PORT >>/home/sysadmin/zhengxin/${OBJ_IP}_SERVICEPORT

            SERVICE_NAME=$(echo "$NAME_LIST" | sed -n "${i}p")
	    
	    if [ x"$SERVICE_NAME" = x"(squid)" ];then
		SERVICE_NAME=squid
	    else 
		:
	    fi
	    echo $SERVICE_NAME >>/home/sysadmin/zhengxin/${OBJ_IP}_SERVICENAME
        done
	scp /home/sysadmin/zhengxin/${OBJ_IP}_SERVICENAME root@${NAGIOS_SERVER}:/root
        scp /home/sysadmin/zhengxin/${OBJ_IP}_SERVICEPORT root@${NAGIOS_SERVER}:/root
    fi
done

scp $MONITOR_OBJ root@${NAGIOS_SERVER}:/root
rm -f *_SERVICENAME *_SERVICEPORT

#add port_monitor to nagios_server
ssh root@${NAGIOS_SERVER} 'bash /usr/local/nagios/nagiosql32/scripts/monitor-ports.sh' &>/dev/null


