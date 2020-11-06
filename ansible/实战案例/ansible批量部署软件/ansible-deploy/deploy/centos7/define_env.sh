#!/bin/bash
#description: ansible实现批量部署应用环境(仅适用于centos7)...
#version: v1.2
#auth: by zhengxin20180720
#email: hzzxin@tairanchina.com

DATE="$(date +%Y%m%d_%H%M)"
DYN_INVENTORY="/ansible-deploy/inventory/centos7_ip_list"
PLAYBOOK_DIR="/ansible-deploy/playbook/centos7"
ENV_PLAYBOOK="$PLAYBOOK_DIR/env_init.yml"
JDK_PLAYBOOK="$PLAYBOOK_DIR/jdk.yml"
TOMCAT_PLAYBOOK="$PLAYBOOK_DIR/tomcat.yml"
NODE1_PLAYBOOK="$PLAYBOOK_DIR/nodejs-v6.11.2.yml"
NODE2_PLAYBOOK="$PLAYBOOK_DIR/nodejs-v8.10.0.yml"
NGINX_PLAYBOOK="$PLAYBOOK_DIR/nginx.yml"
MQ_PLAYBOOK="$PLAYBOOK_DIR/rabbitmq.yml"
LOCAL_REPO_PLAYBOOK="$PLAYBOOK_DIR/local_repo.yml"
ALY_REPO_PLAYBOOK="$PLAYBOOK_DIR/aliyun_repo.yml"
ZK_PLAYBOOK="$PLAYBOOK_DIR/zookeeper.yml"
ZBX_AGENT_PLAYBOOK="$PLAYBOOK_DIR/zabbix-agent.yml"
APP_DIR="/usr/local/weihu/software/centos7"
LOG_DIR="/ansible-deploy/logs/centos7"
APP_LIST=(env_init.tar.gz rabbitmq.tar.gz trc-apr-1.5.2-1.el7.centos.x86_64.rpm trc-apr-iconv-1.2.1-1.el7.centos.x86_64.rpm trc-apr-util-1.5.4-1.el7.centos.x86_64.rpm trc-jdk-1.8.0_77-1.el7.centos.x86_64.rpm trc-nginx-1.12.2-3.el7.centos.x86_64.rpm trc-node-v6.11.2-1.el7.centos.x86_64.rpm trc-node-v8.10.0-1.el7.centos.x86_64.rpm trc-tomcat-8.0.32-1.el7.centos.x86_64.rpm trc-tomcat-native-1.1.34-1.el7.centos.x86_64.rpm trc-zookeeper-3.4.6-1.el7.centos.x86_64.rpm)

##创建日志目录
mkdir -p $LOG_DIR
>$LOG_DIR/${DATE}.log

##记录部署日志
RECORD_LOG() {
    echo "$(date +%F_%T)" "$1" >>$LOG_DIR/${DATE}.log
}

##检测软件安装包是否存在
CHECK_FILE() {
    for i in ${APP_LIST[@]};do
	if ! ls $APP_DIR/${i} &>/dev/null;then
	    RECORD_LOG "${i}: software pkg does not exist..."
	    exit 1
	fi
    done
}

##安装函数
INSTALL() {
    RECORD_LOG "starting install software..."
    ansible-playbook -i $DYN_INVENTORY "$1" 
}
