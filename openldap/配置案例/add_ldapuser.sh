#!/bin/bash
#批量添加ldap账号的脚本；

user_file=/root/user_list
ldap_account_file=/root/ldap_account.ldif
ldap_group_file=/root/ldap_group.ldif

if [ ! -e $user_file ];then
	echo "$0: $user_file isn't exist..."
	exit 1
fi

>$ldap_account_file
>$ldap_group_file

ldap_user_content() {
cat<<EOF >>$ldap_account_file 
	dn: uid=$username,ou=People,dc=in,dc=cnwisdom,dc=com
	uid: $username
	cn: $username
	objectClass: account
	objectClass: posixAccount
	objectClass: top
	objectClass: shadowAccount
	userPassword: $username
	shadowLastChange: 17368
	shadowMin: 0
	shadowMax: 99999
	shadowWarning: 7
	loginShell: /bin/bash
	uidNumber: $user_id
	gidNumber: $group_id
	homeDirectory: /home/$username


EOF
}


ldap_group_content() {
cat<<EOF >>$ldap_group_file 
	dn: cn=$groupname,ou=Group,dc=in,dc=cnwisdom,dc=com
	objectClass: posixGroup
	objectClass: top
	cn: $groupname
	gidNumber: $group_id


EOF
}


for i in `cat $user_file`
do
    if [ $(ldapsearch -LLL -w Cnw1sd0m2o15 -x -H ldap://192.168.2.94/ -D "cn=admin,dc=in,dc=cnwisdom,dc=com" -b "dc=in,dc=cnwisdom,dc=com" "(uid=$i)" | wc -l) -eq 0 ];then
	username=$i
	groupname=$i
	user_id=$(date +%s)
	group_id=$user_id
	ldap_group_content
	ldap_user_content
    else
	echo "account exists..."
	continue
    fi
    sleep 1
done

ldapadd -w Cnw1sd0m2o15 -x -H ldap://192.168.2.94/ -D "cn=admin,dc=in,dc=cnwisdom,dc=com" -f $ldap_group_file &>/dev/null
ldapadd -w Cnw1sd0m2o15 -x -H ldap://192.168.2.94/ -D "cn=admin,dc=in,dc=cnwisdom,dc=com" -f $ldap_account_file &>/dev/null
