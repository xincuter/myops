#!/bin/bash
#description:
#The script is make some files in directory of nagios
##auth by zhengxin 20160420

HOST_FILE=/root/cloud-servers
DEST_DIR=/usr/local/nagios/hosts
HOST_NUM=`cat $HOST_FILE|wc -l`
HOST_NAME_FILE=/root/cloud-hostnames

if [ ! -e $HOST_FILE ] || [ ! -e $HOST_NAME_FILE ];then
        echo "please check files..."
        exit 3
fi


function HOST_CONTEXT {
cat <<EOF >${DEST_DIR}/${HOST_IP}.cfg 
define host {
        host_name                       ${HOST_IP}
        alias                           ${HOST_IP}
        address                         ${HOST_IP}
        hostgroups                      ${HOST_GROUP}
        check_command                   check-host-alive
        max_check_attempts              4
        check_period                    24x7
        contact_groups                  admins
        notification_interval           5
        notification_period             24x7
        register                        1
}
EOF
}

##make cfg_file

function MK_CFG_FILE {
if [ $UID -ne  0 ];then
        echo "must be root can operator..."
        exit 2
fi

if [ ! -e $DEST_DIR ];then
        mkdir $DEST_DIR
fi

if [ ! -e ${DEST_DIR}/${HOST_IP}.cfg ];then
        touch ${DEST_DIR}/${HOST_IP}.cfg
        HOST_CONTEXT
        HOST_NAME=`sed -n "${I}p" $HOST_NAME_FILE`
        sed -i "/host_name/s#${HOST_IP}#${HOST_NAME}#" ${DEST_DIR}/${HOST_IP}.cfg
        sed -i "/alias/s#${HOST_IP}#${HOST_NAME}#" ${DEST_DIR}/${HOST_IP}.cfg
	mv ${DEST_DIR}/${HOST_IP}.cfg ${DEST_DIR}/${HOST_NAME}.cfg
else
        echo " ${HOST_IP}.cfg is exist,you can't change it..."
fi
}



echo -e "Now makeing nagios_host_cfg_file...\n"
read -p "please input host_group: " HOST_GROUP
for I in `seq 1 $HOST_NUM`
do
        HOST_IP=`sed -n "${I}p" $HOST_FILE` 
        if ! ping -c3 $HOST_IP &>/dev/null;then
                echo "$HOST_IP is unreachable..."
        else
                MK_CFG_FILE
        fi
done
