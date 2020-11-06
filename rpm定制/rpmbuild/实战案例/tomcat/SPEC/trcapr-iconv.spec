%define apr_iconv_dir         /usr/local/apr-iconv

Name: trc-apr-iconv
Version: 1.2.1
Release: 1%{?dist}
Summary: APR-iconv provides a portable iconv implementation built on top of APR.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: apr-iconv-1.2.1.tar.gz
Source1: apr-iconv.conf

BuildRoot: %_topdir/BUILDROOT
BuildRequires: gcc
Requires: trc-apr

%description
APR-iconv provides a portable iconv implementation built on top of APR.

%prep
%setup -q -n apr-iconv-1.2.1

%build
./configure \
--prefix=/usr/local/apr-iconv \
--with-apr=/usr/local/apr
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
%{__install} -p -D -m 0644 %{SOURCE1} %{buildroot}/etc/ld.so.conf.d/apr-iconv.conf

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
   if ls -ld %{apr_iconv_dir} &>/dev/null;then
      echo "apr-iconv has been already installed..."
      exit 1
   fi
fi

%post
if [ $1 == 1 ];then
   chown -R root. %{apr_iconv_dir}
   ldconfig
fi

%preun
if [ $1 == 0 ];then
   rm -rf %{apr_iconv_dir}/ &>/dev/null
fi

%postun
if [ $1 == 0 ];then
   rm -f /etc/ld.so.conf.d/apr.conf
   ldconfig
fi

%files
%defattr(-,root,root)
/usr/local/apr-iconv
%attr(0644,root,root) /etc/ld.so.conf.d/apr-iconv.conf

%changelog
* Mon May 15 2018 hzzxin <hzzxin@tairanchina.com> - 1.2.1-1
- Initial version
