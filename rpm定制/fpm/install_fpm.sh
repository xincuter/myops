#!/bin/bash
#description: install fpm(only for centos7)...
#

##安装fpm依赖（fpm是使用ruby写的）
echo "现在开始安装fpm依赖包..."
yum install ruby-devel gcc make rpm-build rubygems -y
echo

##安装fpm
sleep 1
echo "现在开始安装fpm..."
gem install --no-ri --no-rdoc fpm
echo

##安装完成后，查看fpm版本
echo "安装完成查看fpm版本..."
fpm --version
