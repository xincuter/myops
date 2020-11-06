%define tomcat_native_dir         /usr/local/tomcat

Name: trc-tomcat-native
Version: 1.1.34
Release: 1%{?dist}
Summary: The Apache Tomcat Native Library gives Tomcat access to the Apache Portable Runtime (APR) library's network connection (socket) implementation and random-number generator.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: tomcat-native-1.1.34-src.tar.gz
Source1: server.xml
Source2: catalina.sh


BuildRoot: %_topdir/BUILDROOT
BuildRequires: gcc
Requires: trc-jdk,trc-apr,trc-apr-iconv,trc-apr-util,trc-tomcat

%description
The Apache Tomcat Native Library gives Tomcat access to the Apache Portable Runtime (APR) library's network connection (socket) implementation and random-number generator.

%prep
%setup -q -n tomcat-native-1.1.34-src

%build
cd %_topdir/BUILD/tomcat-native-1.1.34-src/jni/native
./configure \
--prefix=/usr/local/tomcat \
--with-apr=/usr/local/apr/bin/apr-1-config \
--with-java-home=/usr/local/java \
--with-ssl=yes
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
cd %_topdir/BUILD/tomcat-native-1.1.34-src/jni/native
make install DESTDIR=%{buildroot}
%{__install} -p -d -m 0755 %{buildroot}/usr/local/tomcat/bak
%{__install} -p -D -m 0644 %{SOURCE1} %{buildroot}/usr/local/tomcat/bak/server.xml
%{__install} -p -D -m 0755 %{SOURCE2} %{buildroot}/usr/local/tomcat/bak/catalina.sh

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
   /usr/sbin/useradd trcweb 2>/dev/null || :
   if ls -l %{tomcat_native_dir}/lib/libtcnative-1.* &>/dev/null;then
      echo "tomcat-native has been already installed..."
      exit 1
   fi
fi

%post
if [ $1 == 1 ];then
   \cp -rf %{tomcat_native_dir}/lib/libtcnative-1.* /usr/lib/
   \cp -f %{tomcat_native_dir}/bak/server.xml %{tomcat_native_dir}/conf/server.xml
   \cp -f %{tomcat_native_dir}/bak/catalina.sh %{tomcat_native_dir}/bin/catalina.sh
   rm -rf %{tomcat_native_dir}/bak
   chown -R trcweb. %{tomcat_native_dir}/
fi

%preun
if [ $1 == 0 ];then
   /usr/sbin/userdel -r trcweb 2>/dev/null
fi

%postun
if [ $1 == 0 ];then
   rm -f /usr/lib/libtcnative-1.*
fi

%files
%defattr(-,root,root)
/usr/local/tomcat

%changelog
* Mon May 15 2018 hzzxin <hzzxin@tairanchina.com> - 1.1.34-1
- Initial version
