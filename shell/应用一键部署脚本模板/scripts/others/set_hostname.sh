#!/bin/bash

HOSTNAME_CONF="/etc/sysconfig/network"
HOSTS_FILE="/etc/hosts"
HOST_IP="$(ifconfig eth0 | grep inet | awk -F'[ :]+' '{print $4}')"

##define function SET_HOSTNAME
SET_HOSTNAME() {
    if ! grep "^#HOSTNAME" $HOSTNAME_CONF &>/dev/null;then
        sed -i".bak" -r -e "/^HOSTNAME=/s@(.*)@#&@g" -e "/^#HOSTNAME=/a\HOSTNAME=$1"  $HOSTNAME_CONF

        ##set hostname
        hostname $1

        ##add domain to /etc/hosts
        echo "${HOST_IP}  $1" >>$HOSTS_FILE    
    fi
}

##main
if [ $# -lt 1 ];then
    echo "Usage: $0: your need to privide 1 parameter,<hostname>..."
    exit 1
fi

SET_HOSTNAME "$1"
