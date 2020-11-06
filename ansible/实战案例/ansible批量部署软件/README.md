说明：(V1版本)
该脚本用于大批量安装各类软件，保证软件环境一致，快速高效完成环境复制。【注：v1版本所有定制化的rpm包都存放在中控机本地，也可以搭建本地yum源，使得部署脚本集更加简洁高效，博主在第二版本中实践非常好用，思路已提供，大家自行实践即可】


脚本目录结构及说明：
/ansible-deploy/                 ##脚本家目录
├── deploy                       ##部署脚本目录
│   ├── centos6
│   │   ├── define_env.sh        ##环境变量文件
│   │   ├── deploy.sh            ##centos 6系列软件部署脚本主入口
│   │   ├── node_deploy.sh       ##centos 6系列node软件多版本部署脚本
│   │   └── repo_deploy.sh       ##centos 6系列yum源文件部署脚本
│   └── centos7
│       ├── define_env.sh
│       ├── deploy.sh
│       ├── node_deploy.sh
│       └── repo_deploy.sh
├── deploy_env.sh                ##部署脚本全局入口
├── inventory                    ##主机清单目录
│   ├── centos6_ip_list          ##操作系统为centos6系列的主机清单
│   └── centos7_ip_list          ##操作系统为centos7系列的主机清单 
├── logs                         ##日志目录
│   ├── centos6
│   │   ├── 20190425_1140.log
│   │   ├── 20190425_1846.log
│   │   └── 20190425_1847.log
│   └── centos7
│       ├── 20181220_1549.log
│       ├── 20181220_1550.log
│       └── 20181225_1458.log
└── playbook                     ##playbook目录，每个软件对应一个playbook，扩展性强（搭建本地yum源，playbook可以通用只需一个即可）
    ├── centos6
    │   ├── aliyun_repo.yml
    │   ├── env_init.yml
    │   ├── jdk.yml
    │   ├── local_repo.yml
    │   ├── nginx.yml
    │   ├── nodejs-v6.11.2.yml
    │   ├── nodejs-v8.10.0.yml
    │   ├── rabbitmq.yml
    │   ├── tomcat.yml
    │   ├── zabbix-agent.yml
    │   └── zookeeper.yml
    └── centos7
        ├── aliyun_repo.yml
        ├── env_init.yml
        ├── jdk.yml
        ├── local_repo.yml
        ├── nginx.yml
        ├── nodejs-v6.11.2.yml
        ├── nodejs-v8.10.0.yml
        ├── rabbitmq.yml
        ├── tomcat.yml
        ├── zabbix-agent.yml
        └── zookeeper.yml       


脚本执行说明：
（1）在inventory目录中，将对应系统版本的主机地址列表写入文件；
（2）cd /ansible-deploy/ && sh deploy_env.sh即可。

注：如果软件非常多可结合jenkins实现web触发
