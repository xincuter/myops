%define apr_util_dir         /usr/local/apr-util

Name: trc-apr-util
Version: 1.5.4
Release: 1%{?dist}
Summary: APR-util provides a number of helpful abstractions on top of APR.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: apr-util-1.5.4.tar.gz
Source1: apr-util.conf

BuildRoot: %_topdir/BUILDROOT
BuildRequires: gcc
Requires: trc-apr,trc-apr-iconv

%description
APR-util provides a number of helpful abstractions on top of APR.

%prep
%setup -q -n apr-util-1.5.4

%build
./configure \
--prefix=/usr/local/apr-util \
--with-apr=/usr/local/apr \
--with-apr-iconv=/usr/local/apr-iconv/bin/apriconv
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
%{__install} -p -D -m 0644 %{SOURCE1} %{buildroot}/etc/ld.so.conf.d/apr-util.conf

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
   if ls -ld %{apr_util_dir} &>/dev/null;then
      echo "apr-util has been already installed..."
      exit 1
   fi
fi

%post
if [ $1 == 1 ];then
   chown -R root. %{apr_util_dir}/
   ldconfig
fi

%preun
if [ $1 == 0 ];then
   rm -rf %{apr_util_dir}/ &>/dev/null
fi

%postun
if [ $1 == 0 ];then
   rm -f /etc/ld.so.conf.d/apr-util.conf
   ldconfig
fi

%files
%defattr(-,root,root)
/usr/local/apr-util
%attr(0644,root,root) /etc/ld.so.conf.d/apr-util.conf

%changelog
* Mon May 15 2018 hzzxin <hzzxin@tairanchina.com> - 1.5.4-1
- Initial version
