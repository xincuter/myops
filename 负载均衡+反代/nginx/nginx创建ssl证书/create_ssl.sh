#!/bin/bash
#description: 创建本地私有证书...

#创建CA证书的私钥文件
cd /etc/pki/CA/
(umask 077;openssl genrsa -out /etc/pki/CA/private/cakey.pem 2048)


#创建CA自签证书
openssl req -new -x509 -key  /etc/pki/CA/private/cakey.pem -days 3650 -out /etc/pki/CA/cacert.pem

#创建所需要的记录文件
touch /etc/pki/CA/{index.txt,serial}
echo "00" >/etc/pki/CA/serial


##配置nginx支持ssl
NGINX_SSL_DIR=/usr/local/nginx/ssl
NGINX_PRIVATE_KEY=/usr/local/nginx/ssl/nginx.key
NGINX_SSL_CSR=/usr/local/nginx/ssl/nginx.csr
NGINX_SSL_CRT=/usr/local/nginx/ssl/nginx.crt

##在nginx主目录创建ssl目录
mkdir $NGINX_SSL_DIR

##生成nginx自己的证书私钥文件
(umask 077;openssl genrsa -out $NGINX_PRIVATE_KEY 2048)

#向私有CA机构发起证书签署请求；注意：证书签署请求中国家组织等信息要与CA自签证书一致一样；
openssl req -new -key $NGINX_PRIVATE_KEY -days 365 -out  $NGINX_SSL_CSR

#在私有CA服务器上验证该ca签署请求并签署请求
openssl ca -in $NGINX_SSL_CSR -out $NGINX_SSL_CRT -days 365
