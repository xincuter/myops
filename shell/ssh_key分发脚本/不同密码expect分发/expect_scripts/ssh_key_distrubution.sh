#!/bin/bash
#script_name: ssh_key_distribution.sh
#description: distribution ansible-server ssh-key to remote servers in order to free authentication...
#

SOURCE=/root
IP_FILE=$SOURCE/expect_scripts/ip_file
PASSWD_FILE=$SOURCE/expect_scripts/password.txt
REMOTE_USER='root'
#PASSWORD='Tairan@1102#'
#PASSWORD='Tairan@1027#9!'
SSH_KEY_FILE=/root/.ssh/id_rsa.pub
EXPECT_SCRIPT=$SOURCE/expect_scripts/ssh_key_expect.exp

if [ ! -f $IP_FILE ];then
     echo "$IP_FILE not exists..."
     exit 1
fi

if [ ! -s $IP_FILE ] || [ ! -s $PASSWD_FILE ];then
     echo "file size is wrong..."
     exit 1
fi

if ! which expect &>/dev/null;then
     yum install expect -y &>/dev/null 
     if [ $? -ne 0 ];then
	echo "yum install expect failed..."
        exit 1
     fi
fi

for i in $(seq 1 $(cat $IP_FILE | wc -l));do
     HOST_IP=$(sed -n "${i}p" $IP_FILE)
     PASSWORD=$(sed -n "${i}p" $PASSWD_FILE)
     expect "$EXPECT_SCRIPT" "$SSH_KEY_FILE" "$REMOTE_USER" "$HOST_IP" "$PASSWORD"
     if [ $? -eq 0 ];then
	echo "$HOST_IP distrubute successfully..."
     else
	echo "$HOST_IP distrubute failed..."
     fi
done 
