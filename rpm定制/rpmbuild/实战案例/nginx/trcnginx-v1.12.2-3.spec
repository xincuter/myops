%define nginx_user myweb
%define nginx_group %{nginx_user}
%define nginx_conf_dir /usr/local/nginx/conf
%define nginx_html_dir /usr/local/nginx/html
%define service_name nginx

Name: trc-nginx
Version: 1.12.2
Release: 3%{?dist}
Summary: A free,open-source,High-performance HTTP server and reverse proxy,as well as an IMAP/POP3 proxy server.

Vendor: TRC
Group: Applications/Archiving
License: GPLv2
URL: http://repos.in.trc.com/trc_software
Packager: hzzxin <hzzxin@tairanchina.com>
Source0: %{name}-%{version}.tar.gz
Source1: nginx.conf
Source2: nginx
Source3: index.html
Source4: nginx.sh
Source5: fastcgi_params
Source6: default.conf
Source7: trc-fastcgi.conf
Source8: nginx_logrotate
Source9: gzip_nginx_log.sh

BuildRoot: %_topdir/BUILDROOT

BuildRequires: gcc
Requires: openssl,openssl-devel,pcre-devel,pcre,gd,gd-devel,zlib-devel,psmisc

%description
Nginx is a free,open-source,High-performance HTTP server and reverse proxy,
as well as an IMAP/POP3 proxy server.

%prep
%setup -q


%build

./configure \
--prefix=/usr/local/nginx \
--user=myweb \
--group=myweb \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_flv_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx/nginx.lock \
--with-http_dav_module \
--http-log-path=/usr/local/nginx/logs/ \
--http-client-body-temp-path=/usr/local/nginx/client_temp \
--http-proxy-temp-path=/usr/local/nginx/proxy_temp \
--http-fastcgi-temp-path=/usr/local/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/usr/local/nginx/uwsgi_temp \
--with-stream \
--with-pcre \
--with-http_image_filter_module
make %{?_smp_mflags}


%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}
%{__install} -p -D -m 0755 %{SOURCE2} %{buildroot}/etc/rc.d/init.d/nginx
%{__install} -p -D -m 0644 %{SOURCE1} %{buildroot}/usr/local/nginx/conf/nginx.conf
%{__install} -p -D -m 0644 %{SOURCE3} %{buildroot}/usr/local/nginx/html/index.html
%{__install} -p -D -m 0755 %{SOURCE4} %{buildroot}/etc/profile.d/nginx.sh
%{__install} -p -D -m 0644 %{SOURCE5} %{buildroot}/usr/local/nginx/conf/fastcgi_params
%{__install} -p -D -m 0644 %{SOURCE7} %{buildroot}/usr/local/nginx/conf/trc-fastcgi.conf
#%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/conf.d/server
#%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/conf.d/upstream
%{__install} -p -D -m 0644 %{SOURCE6} %{buildroot}/usr/local/nginx/conf.d/server/default.conf
%{__install} -p -D -m 0644 %{SOURCE8} %{buildroot}/usr/local/weihu/logrotate/nginx/nginx
%{__install} -p -D -m 0755 %{SOURCE9} %{buildroot}/usr/local/weihu/logrotate/nginx/gzip_nginx_log.sh
%{__install} -p -d -m 0755 %{buildroot}/var/run/nginx
%{__install} -p -d -m 0755 %{buildroot}/var/lock/nginx
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/client_temp
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/proxy_temp
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/fastcgi_temp
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/uwsgi_temp
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/conf.d/server
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/conf.d/upstream
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/logs
%{__install} -p -d -m 0755 %{buildroot}/usr/local/nginx/ssl

%clean
rm -rf %{buildroot}

%pre
if [ $1 == 1 ];then
    /usr/sbin/useradd -s /bin/false -r myweb 2>/dev/null || :
fi

%post
if [ $1 == 1 ];then
    /sbin/chkconfig --add %{service_name}
    chown -R %{nginx_user}. /var/run/nginx /var/lock/nginx
    chown -R %{nginx_user}. /usr/local/nginx

    ##logrotate nginx log
    echo -e "##logrotate nginx log\n59 23 * * * /usr/sbin/logrotate -f /usr/local/weihu/logrotate/nginx/nginx &>/dev/null" >>/var/spool/cron/root

    ##compress nginx history log
    echo -e "##compress nginx history log\n00 3 * * * sh /usr/local/weihu/logrotate/nginx/gzip_nginx_log.sh &>/dev/null" >>/var/spool/cron/root

    source /etc/profile.d/nginx.sh
fi

%preun
if [ $1 == 0 ];then
    /sbin/service %{service_name} stop &>/dev/null
    /sbin/chkconfig --del %{service_name}
    sed -i "/##logrotate nginx log/,+1d" /var/spool/cron/root
    sed -i "/##compress nginx history log/,+1d" /var/spool/cron/root
fi

%postun
if [ $1 == 0 ];then
    rm -rf /usr/local/nginx
	userdel -r myweb
fi

%files
%defattr(-,root,root)
%doc LICENSE CHANGES README
%dir /var/run/nginx
%dir /var/lock/nginx
%dir /usr/local/nginx/client_temp
%dir /usr/local/nginx/proxy_temp
%dir /usr/local/nginx/fastcgi_temp
%dir /usr/local/nginx/uwsgi_temp
%config(noreplace) %{nginx_conf_dir}/win-utf
%config(noreplace) %{nginx_conf_dir}/mime.types.default
%config(noreplace) %{nginx_conf_dir}/fastcgi.conf
%config(noreplace) %{nginx_conf_dir}/fastcgi.conf.default
%config(noreplace) %{nginx_conf_dir}/fastcgi_params
%config(noreplace) %{nginx_conf_dir}/fastcgi_params.default
%config(noreplace) %{nginx_conf_dir}/mime.types
%config(noreplace) %{nginx_conf_dir}/scgi_params
%config(noreplace) %{nginx_conf_dir}/scgi_params.default
%config(noreplace) %{nginx_conf_dir}/uwsgi_params
%config(noreplace) %{nginx_conf_dir}/uwsgi_params.default
%config(noreplace) %{nginx_conf_dir}/koi-win
%config(noreplace) %{nginx_conf_dir}/koi-utf
%config(noreplace) %{nginx_conf_dir}/nginx.conf.default
%config(noreplace) %{nginx_conf_dir}/nginx.conf
%config(noreplace) %{nginx_conf_dir}/trc-fastcgi.conf
%{nginx_html_dir}/50x.html
%{nginx_html_dir}/index.html
/usr/local/nginx/sbin/nginx
/usr/local/nginx/conf.d
/usr/local/nginx/ssl
/usr/local/nginx/logs
/usr/local/weihu/logrotate/nginx
%attr(0755,root,root) /etc/rc.d/init.d/nginx
%attr(0755,root,root) /etc/profile.d/nginx.sh


%changelog
* Wed Jan 16 2019 hzzxin <hzzxin@tairanchina.com> - 1.12.2-3
- Third   version
* Wed Jan 16 2019 hzzxin <hzzxin@tairanchina.com> - 1.12.2-2
- Second  version
* Thu May 10 2018 hzzxin <hzzxin@tairanchina.com> - 1.12.2-1
- Initial version
