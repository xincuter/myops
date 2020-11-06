VIP="$1"


if [ "x${VIP}" = "x" ]; then
    echo "need vip"
    exit 1
fi

echo "

net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
" >> /etc/sysctl.conf

sysctl -p


echo "DEVICE=lo:0
IPADDR=${VIP}
NETMASK=255.255.255.255
BROADCAST=${VIP}
ONBOOT=yes
" > /etc/sysconfig/network-scripts/ifcfg-lo\:0


service network restart


