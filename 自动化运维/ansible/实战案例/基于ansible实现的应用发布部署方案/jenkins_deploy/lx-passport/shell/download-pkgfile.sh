#!/bin/bash
#description: download update package files from sftp server...
#version: v1.0
#author: by zhengxin20190304
#email: hzzxin@tairanchina.com

##define variables
DATE=$(date +%Y%m%d)
SFTP_DIR="/datefiles/lx/upload/passport"
LOCAL_DIR="/jenkins_deploy/lx-passport/sftp"
SFTP_SERVER="10.203.209.22"
SFTP_PORT="25862"
SFTP_USER="80FwbpQK"

##download all pkg files 
DOWNLOAD_ALL_PKG() {
    if ssh -p ${SFTP_PORT} ${SFTP_USER}@${SFTP_SERVER} "ls -ld ${SFTP_DIR}/${DATE}" &>/dev/null;then
        echo "Now,starting download update package files of ${DATE}..."
        rsync -avH -e "ssh -p ${SFTP_PORT}" ${SFTP_USER}@${SFTP_SERVER}:${SFTP_DIR}/${DATE} $LOCAL_DIR/
    else
        echo "Sorry,no update package files of ${DATE},please build projects first or check it..."
        exit 1
    fi
}

##download per project pkg files
DOWNLOAD_PER_PKG() {
    if ssh -p ${SFTP_PORT} ${SFTP_USER}@${SFTP_SERVER} "ls -ld ${SFTP_DIR}/${DATE}/$1" &>/dev/null;then
        echo "Now,starting download update package files of project[$1]..."
        [ -d $LOCAL_DIR/$DATE/$1 ] || mkdir -p $LOCAL_DIR/$DATE/$1
        rsync -avH -e "ssh -p ${SFTP_PORT}" ${SFTP_USER}@${SFTP_SERVER}:${SFTP_DIR}/${DATE}/$1/ $LOCAL_DIR/$DATE/$1
    else
        echo "Sorry,no update package files of project[$1],please build project first or check it..."
        exit 1
    fi
}
