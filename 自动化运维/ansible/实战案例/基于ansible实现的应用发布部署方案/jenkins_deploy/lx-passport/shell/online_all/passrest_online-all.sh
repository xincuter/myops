#!/bin/bash
#description: nginx端上线所有passrest服务...
#version: v1.0
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

UPSTREAM_GROUP="passrest"
ANSIBLE_CMD="/usr/bin/ansible"
NGINX_SERVER="10.206.188.23"
UPSTREAM_FILE="upstream_passrest.conf"
NGINX_CONF_DIR="/jenkins_deploy/lx-passport/nginx"

##nginx上线所有passrest服务
NGINX_ONLINE_ALL() {
    $ANSIBLE_CMD "$NGINX_SERVER" -m copy -a "src=${NGINX_CONF_DIR}/$UPSTREAM_FILE dest=/usr/local/nginx/conf.d/upstream/$UPSTREAM_FILE" &>/dev/null
    if [ $? -eq 0 ];then
        CHECK_INFO=$(ssh root@$NGINX_SERVER "service nginx check 2>/dev/null")
        if echo "$CHECK_INFO" | grep "nginx check failed" &>/dev/null;then
            echo "nginx configuration file check failed,please check..."
            exit 1
        fi
        echo "nginx configuration file check successed,reload it: "
        ssh root@$NGINX_SERVER 'service nginx reload 2>/dev/null' 
    else
	exit 1
    fi

    ##查看nginx upstream组配置
    echo -e "\nupstream information[$UPSTREAM_GROUP] As follow: "
    $ANSIBLE_CMD "$NGINX_SERVER" -m shell -a "cat /usr/local/nginx/conf.d/upstream/$UPSTREAM_FILE"
}

##main
NGINX_ONLINE_ALL
