%define tomcat_dir         /usr/local/tomcat

Name: trc-tomcat
Version: 8.0.32
Release: 1%{?dist}
Summary: An open source implementation of the Java Servlet.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: apache-tomcat-8.0.32.tar.gz
Source1: monitor.tar.gz
Source2: tomcat.sh
Source3: tomcat8080
Source4: tomcat

BuildRoot: %_topdir/BUILDROOT
BuildRequires: gcc
Requires: trc-jdk

%description
The Apache Tomcat software is an open source implementation of the Java Servlet,
JavaServer Pages,Java Expression Language and Java WebSocket technologies. 

%prep
%setup -q -n apache-tomcat-8.0.32
%setup -b 1 -n monitor

%install
rm -rf %{buildroot}
%{__install} -p -D -m 0755 %{SOURCE2} %{buildroot}/etc/profile.d/tomcat.sh
%{__install} -p -D -m 0755 %{SOURCE3} %{buildroot}/etc/init.d/tomcat8080
%{__install} -p -D -m 0644 %{SOURCE4} %{buildroot}/usr/local/weihu/logrotate/tomcat
%{__install} -p -d -m 0755 %{buildroot}/usr/local/apache-tomcat-8.0.32
%{__install} -p -d -m 0755 %{buildroot}/usr/local/apache-tomcat-8.0.32/monitor
\cp -ar %_topdir/BUILD/apache-tomcat-8.0.32/* %{buildroot}/usr/local/apache-tomcat-8.0.32/
\cp -ar %_topdir/BUILD/monitor/* %{buildroot}/usr/local/apache-tomcat-8.0.32/monitor/

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
   /usr/sbin/useradd trcweb 2>/dev/null || :
   if ls -ld %{tomcat_dir} &>/dev/null;then
        rm -rf %{tomcat_dir} &>/dev/null
   fi
fi

%post
if [ $1 == 1 ];then
   ln -sf /usr/local/apache-tomcat-8.0.32 %{tomcat_dir}

   rm -rf /usr/local/tomcat/webapps/*

   ##install monitor
   mv %{tomcat_dir}/monitor %{tomcat_dir}/webapps/

   chown -R trcweb. %{tomcat_dir}/
   source /etc/profile.d/tomcat.sh

   ##logrotate tomcat log
   echo -e "##logrotate tomcat log\n59 23 * * * /usr/sbin/logrotate -f /usr/local/weihu/logrotate/tomcat &>/dev/null" >>/var/spool/cron/root
fi

%preun
if [ $1 == 0 ];then
   /usr/sbin/userdel -r trcweb 2>/dev/null
   rm -rf %{tomcat_dir} /usr/local/apache-tomcat-8.0.32  &>/dev/null
   sed -i "/##logrotate tomcat log/,+1d" /var/spool/cron/root
fi

%postun
if [ $1 == 0 ];then
   rm -f /etc/profile.d/tomcat.sh
   rm -f /etc/init.d/tomcat8080
   rm -f /usr/local/weihu/logrotate/tomcat
fi

%files
%defattr(-,root,root)
/usr/local/apache-tomcat-8.0.32
%attr(0755,root,root) /etc/profile.d/tomcat.sh
%attr(0755,root,root) /etc/init.d/tomcat8080
%attr(0755,root,root) /usr/local/weihu/logrotate/tomcat 

%changelog
* Mon Mar 7 2018 hzzxin <hzzxin@tairanchina.com> - 8.0.32-1
- Initial version
