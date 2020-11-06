#!/bin/bash
##description: template of dubbo jvm check script...
##auth: by zhengxin20180706
##email: hzzxin@tairanchina.com

##source function library
. /etc/init.d/functions

##source env
. /etc/profile

PROJ_NAME="$1"
CHECK_CMD="/usr/local/jdk1.8.0_77/bin/jstat"

if [ x"$1" = x"" ];then
    echo "Usage: $0 {dubbo_app_name  <OLD|PERM|YGC|YGCT|FGC|FGCT|GCT|THREADS|PIDNUM>}..."
    exit 1
fi

##number of dubbo process
PID_NUM="$(ps -ef | grep "[j]ava" | grep "\<$PROJ_NAME\>/" | wc -l)"

##check pid_num
if [ $PID_NUM -eq 1 ];then
    ##get dubbo process pid
    PID="$(ps -ef | grep "[j]ava" | grep "\<$PROJ_NAME\>/" | awk '{print $2}')"
    ##get jvm info and save to vars
    JVM_INFO="$(sudo $CHECK_CMD -gcutil $PID)"
    ##Old space utilization
    OLD="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $4}')"
    ##Metaspace utilization
    PERM="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $5}')"
    ##Number of young generation GC events
    YGC="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $7}')"
    ##Young generation garbage collection time
    YGCT="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $8}')"
    ##Number of full GC events
    FGC="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $9}')"
    ##Full garbage collection time
    FGCT="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $10}')"
    ##Total garbage collection time
    GCT="$(echo "${JVM_INFO}" | grep -v "E" | awk '{print $11}')"
    ##number of threads
    THREADS="$(ps -Lf -p $PID | grep "\<$PID\>" | wc -l)"
fi

case $2 in
OLD)
    echo $OLD
    ;;
PERM)
    echo $PERM
    ;;
YGC)
    echo $YGC
    ;;
YGCT)
    echo $YGCT
    ;;
FGC)
    echo $FGC
    ;;
FGCT)
    echo $FGCT
    ;;
GCT)
    echo $GCT
    ;;
THREADS)
    echo $THREADS
    ;;
PIDNUM)
    echo $PID_NUM
    ;;
*)
    echo "Usage: $0 {dubbo_app_name  <OLD|PERM|YGC|YGCT|FGC|FGCT|GCT|THREADS|PIDNUM>}..."
    ;;
esac

exit 0