jenkins + ansible + shell实现自动化发布部署方案!!!


发布部署方案流程图：
回归测试完成 ---> 版本封版，打tag ---> 基于tag构建代码包 ---> 推送包仓库(sftp) ---> 下载源码包并分发至应用服务器上 ---> 并分批次部署（涉及负载均衡上下线操作）---> 检测服务 

说明：
jenkins_deploy/lx-passport/                     #业务工程目录
├── logs                                        #部署日志        
│   ├── rollback                                 ##应用回滚日志
│   └── update                                   ##应用更新日志  
├── nginx                                       #nginx upstream组文件
│   ├── upstream_account-sync.conf
│   ├── upstream_account-sync.conf-part01
│   ├── upstream_account-sync.conf-part02
│   ├── upstream_captcha.conf
│   ├── upstream_captcha.conf-part01
│   ├── upstream_captcha.conf-part02
│   ├── upstream_passrest.conf
│   ├── upstream_passrest.conf-part01
│   └── upstream_passrest.conf-part02
├── playbook                                    #ansible playbook，实现一键分发应用脚本、日志切割脚本等等
│   ├── trans_dubbo_logrotate_script.yml
│   ├── trans_dubbo_update_script.yml
│   └── trans_tomcat_script.yml
├── sftp                                        #应用包下载拉取暂存目录，目录路径格式：${SOURCE}/sftp/${日期(%Y%m%d)}/${APP_NAME}/${APP_NAME}.{zip|war|...}-{tag版本号}
│   ├── 20190411
│   ├── 20190418
│   └── README.md
└── shell                                       #脚本程序目录
    ├── deploy                                   ##ansible部署更新主脚本目录
    ├── download-pkgfile.sh                      ##一键拉取应用软件包脚本，主脚本程序会加载该脚本函数，进行更新包拉取操作，并保存于业务工程目录下的sftp目录中
    ├── online_all                               ##服务上下线脚本
    ├── rollback                                 ##ansible回滚主脚本目录
    └── scripts                                  ##各应用更新脚本模板
