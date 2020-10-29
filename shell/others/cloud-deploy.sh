#!/bin/bash
SWAP_UUID_FILE=/tmp/swapuuid
YUM_REPO=/tmp/cnwisdom.repo
MYSQL_CONFIG_FILE=/tmp/my.cnf
TOMCAT_DIR=/home/admin/tomcat
APACHE_DIR=/home/admin/apache

##deploy cloud-servers

echo "now,starting deploy cloud-servers..."
echo 

sleep 2

##disabled selinux
SELINUX_STATUS=`getenforce`
if [ x"$SELINUX_STATUS" = x"Enforcing" ];then
    setenforce 0
    sed -i "/^SELINUX=/s#SELINUX=.*#SELINUX=disabled#g" /etc/sysconfig/selinux
fi

##fdisk the virtual_disk of cloud_servers and install file-system

echo -e "\033[31mwarning...\n\nshow $HOST_IP disks...\n\033[0m"
fdisk -l 2>/dev/null| grep -o "Disk /dev/[shv]d[a-z]"

echo 

sleep 1

read -p "please input disk:" PARTDISK
if [ x"$PARTDISK" == x"quit" ];then
    echo "quiting..."
    exit 7
fi

echo 

until fdisk -l 2>/dev/null| grep -o "^Disk /dev/[shv]d[a-z]"| grep "^Disk $PARTDISK" &>/dev/null
do
    read -p "no such disk,again:" PARTDISK
done



read -p "the operation will destory all data:" CHOICE

echo

until [ $CHOICE = 'y' -o $CHOICE = 'n' ]
do
    read -p "the operation will destory all data,continue?(y|n)  " CHOICE
done

if [ "$CHOICE" = "n" ];then
    echo "not partition,quiting..."
    exit 9
else
    echo "n
          p
          1
          
          
          w" | fdisk $PARTDISK  &>/dev/null

    partprobe $PARTDISK&>/dev/null
fi

echo

echo -e "partition is sucessful,show the disk:\n"
fdisk -l $PARTDISK
    
if [ $? -eq 0 ];then
    echo "next,installing file-system... "
else
    exit 1
fi

sleep 2

pvcreate ${PARTDISK}1

vgcreate vg_00 ${PARTDISK}1

lvcreate -n lv_home -L 16G vg_00
mkfs.ext4 -j /dev/mapper/vg_00-lv_home
lvcreate -n lv_data -L 8G vg_00
mkfs.ext4 -j /dev/mapper/vg_00-lv_data
lvcreate -n lv_mongo -L 8G vg_00
mkfs.ext4 -j /dev/mapper/vg_00-lv_mongo
lvcreate -n lv_cache -L 8G vg_00
mkfs.ext4 -j /dev/mapper/vg_00-lv_cache
lvcreate -n lv_newlog -L 8G vg_00
mkfs.ext4 -j /dev/mapper/vg_00-lv_newlog
lvcreate -n lv_swap -L 4G vg_00
mkswap /dev/mapper/vg_00-lv_swap

mkdir -p /mongo
mkdir -p /cache
mkdir -p /data
mkdir -p /newlog
     
blkid /dev/mapper/vg_00-lv_swap | awk -F '[ :]+' '{print $2}' | sed 's#"##g' >$SWAP_UUID_FILE
sed -i "s#.*#&    swap swap  defaults             1 2#g" $SWAP_UUID_FILE

cat <<EOF >>/etc/fstab
/dev/mapper/vg_00-lv_data        /data     ext4       defaults              1 2
/dev/mapper/vg_00-lv_mongo       /mongo    ext4       defaults              1 2
/dev/mapper/vg_00-lv_cache       /cache    ext4       defaults              1 2
/dev/mapper/vg_00-lv_home        /home     ext4       defaults              1 2
EOF
    
cat $SWAP_UUID_FILE >>/etc/fstab
mount -a
swapon -a

##set environment variables
cp /tmp/{check_portal.sh,console-ps1.sh} /etc/profile.d/


##cp cnwisdom.repo from local to cloud_servers
cp $YUM_REPO /etc/yum.repos.d/

##yum install packages
if ls /etc/yum.repos.d/cnwisdom.repo &>/dev/null;then
     yum install epel-release hd-tomcat hd-httpd haproxy mysql mysql-server mongodb mongodb-server freeradius freeradius-utils freeradius-mysql squid hd-activemq hd-sms hd_snmp_extend MySQL-python -y &>/dev/null
fi

##modified /etc/sysctl.conf
sed -i "s#net.ipv4.ip_forward = 0#net.ipv4.ip_forward = 1#g" /etc/sysctl.conf
echo -e "net.ipv4.tcp_keepalive_time = 60\nnet.ipv4.tcp_keepalive_probes = 3\nnet.ipv4.tcp_keepalive_intvl = 5" >>/etc/sysctl.conf
sysctl -p


##change privileges
chown  -R  mysql:mysql  /data
chown -R  mongodb:mongodb  /mongo
chown  -R  squid:squid  /cache


##initialize mysql
cp $MYSQL_CONFIG_FILE /etc/
sed -i "/^datadir.*/s#.*#datadir=/data#" /etc/my.cnf
if ! grep "datadir=/data$" /etc/my.cnf &>/dev/null;then
    echo "mysql_config modified is false..."
    exit 1
else
    echo "next,exec /usr/bin/mysql_secure_installation..."
    /etc/init.d/mysqld start
    cp /usr/bin/mysql_secure_installation /usr/bin/mysql_secure_installation.bak
    cp /tmp/mysql_secure_installation /usr/bin/mysql_secure_installation
    /usr/bin/mysql_secure_installation
    mysql -uroot -pWisdomHotelMySql -e 'CREATE DATABASE `db_freeradius` /*!40100 DEFAULT CHARACTER SET utf8 */'
    mysql -uroot -pWisdomHotelMySql db_freeradius </tmp/db_freeradius.sql
    /etc/init.d/mysqld restart
fi

##modified mongodb.conf
sed -i "/^dbpath =/s#/var/lib/mongodb#/mongo#g" /etc/mongodb.conf
/etc/init.d/mongod start

##modified haproxy.cfg
\cp /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg
sed -i "/bind :80/s#80#8888#g" /etc/haproxy/haproxy.cfg
/etc/init.d/haproxy start

##modified rsyslog.conf
sed -i "/local7\.\*                                                \/var\/log\/boot\.log/a local2.*                                                /var/log/haproxy.log" /etc/rsyslog.conf
sed -i -r "/\/var\/log\/messages/s#(.*none)(.*)#\1;local2.none\2#g" /etc/rsyslog.conf
/etc/init.d/rsyslog restart

##modified squid
\cp /tmp/squid.conf /etc/squid/
sed -i "/p011.c.easyon.cn/s#p011\.c\.easyon\.cn#`hostname`#g" /etc/squid/squid.conf
chown -R squid. /etc/squid
/etc/init.d/squid start

##cp tomcat and apache config_file
chown -R admin:admingroup /tmp/{*.properties,httpd.conf,portal_jsonp.jsonp,tomcat}
\cp /tmp/*.properties $TOMCAT_DIR/conf/
\cp /tmp/tomcat $TOMCAT_DIR/bin/
\cp /tmp/httpd.conf $APACHE_DIR/conf/
\cp /tmp/portal_jsonp.jsonp $APACHE_DIR/
sed -i "/^edition.cdn_servers/s#p011.c.easyon.cn#`hostname`#g" $TOMCAT_DIR/conf/mercury.properties

##create tomcat-apache dir and file
mkdir $TOMCAT_DIR/webapps/ROOT
echo "OK" >$TOMCAT_DIR/webapps/ROOT/haproxy_check.html
mv $APACHE_DIR/html $APACHE_DIR/html.org
echo "OK" >$APACHE_DIR/haproxy_check.html

chown -R admin:admingroup /home/admin
    
##cp radius files
\cp /tmp/dictionary.mikrotik /usr/share/freeradius/
\cp -rf /tmp/raddb/* /etc/raddb/
/etc/init.d/radiusd start

##modified iptables 
cat /tmp/iptables_policy >/etc/sysconfig/iptables
/etc/init.d/iptables restart

##yum install albatross-client
yum install /tmp/albatross-client-0.1.0-1.el6.x86_64.rpm -y &>/dev/null
/etc/init.d/albatross start

##cp logrotate.sh
if ! ls -l /root/bin &>/dev/null;then
    mkdir /root/bin
fi

if ! ls /root/bin/logrotate.sh &>/dev/null;then
    cp /tmp/logrotate.sh /root/bin
fi

##add crontab for root
if ! grep "/root/bin/logrotate.sh" /var/spool/cron/root &>/dev/null;then
    echo "10 2 * * * /root/bin/logrotate.sh > /tmp/logrotate.cron.log 2>/tmp/logrotate.cron.err" >>/var/spool/cron/root
fi

if ! grep "/etc/init.d/albatross" /var/spool/cron/root &>/dev/null;then
    echo "5 * * * * /etc/init.d/albatross restart > /tmp/albatross.cron.log 2>&1" >>/var/spool/cron/root
fi

if ! grep "/root/bin/gzip_albatross_log" /var/spool/cron/root &>/dev/null;then
    echo "00 5 * * 7 /root/bin/gzip_albatross_log &>/dev/null" >>/var/spool/cron/root
fi

crontab -l


##add chkconfig

chkconfig hd-httpd on
chkconfig hd-tomcat on
chkconfig mongod on
chkconfig mysqld on
chkconfig squid on
chkconfig radiusd on
chkconfig haproxy on
chkconfig iptables on
chkconfig albatross on
chkconfig openvpn on
