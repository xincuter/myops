本目录中centos6与centos7对应的spec文件是一致的，只是对应的”制作工厂“的宿主机系统版本不一样（安装时依赖包版本会不一样），目录中src.rpm是源码包，可以通过命令展开获取源材料及spec文件！！！


示例：
查看src的rpm包中有哪些文件：
rpm2cpio trc-tomcat-8.0.32-1.el6.src.rpm | cpio -t

展开src的rpm包：
rpm2cpio trc-tomcat-8.0.32-1.el6.src.rpm | cpio -id

对于src的rpm包，使用rpmbuild --rebuild可以制作成rpm包
