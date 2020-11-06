%define apr_dir         /usr/local/apr

Name: trc-apr
Version: 1.5.2
Release: 1%{?dist}
Summary: APR is the base portability library.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: apr-1.5.2.tar.gz
Source1: apr.conf

BuildRoot: %_topdir/BUILDROOT
BuildRequires: gcc

%description
APR is the base portability library.

%prep
%setup -q -n apr-1.5.2

%build
./configure \
--prefix=/usr/local/apr
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
%{__install} -p -D -m 0644 %{SOURCE1} %{buildroot}/etc/ld.so.conf.d/apr.conf

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
   if ls -ld %{apr_dir} &>/dev/null;then
      echo "apr has been already installed..."
      exit 1
   fi
fi

%post
if [ $1 == 1 ];then
   chown -R root. %{apr_dir}/
   echo 'export LD_LIBRARY_PATH=/usr/local/apr/lib' >>/etc/profile
   source /etc/profile
   ldconfig
fi

%preun
if [ $1 == 0 ];then
   rm -rf %{apr_dir}/ &>/dev/null
fi

%postun
if [ $1 == 0 ];then
   rm -f /etc/ld.so.conf.d/apr.conf
   ldconfig
fi

%files
%defattr(-,root,root)
/usr/local/apr
%attr(0644,root,root) /etc/ld.so.conf.d/apr.conf

%changelog
* Mon May 15 2018 hzzxin <hzzxin@tairanchina.com> - 1.5.2-1
- Initial version
