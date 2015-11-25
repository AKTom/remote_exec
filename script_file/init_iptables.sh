#!/bin/bash

#清空防火墙规则，如不需要请注释下面一句
iptables -P INPUT ACCEPT
iptables -F
iptables -X
iptables -Z

#开启端口范例
#	iptables -A INPUT -p tcp -d $Destination_ip --dport $port -j ACCEPT
#	iptables -A INPUT -p tcp -d $Destination_ip -j ACCEPT
#	iptables -A INPUT -p tcp --dport $port -j ACCEPT
#	iptables -A INPUT -p tcp -s $source_ip -j DROP
#	iptables -A INPUT -p tcp --dport 1:10 -j ACCEPT

#端口转发,先开启端口转发功能
#	echo "1">/proc/sys/net/ipv4/ip_forward
#	sed -i "s/^net.ipv4.ip_forward.*$/net.ipv4.ip_forward = 1/g" /etc/sysctl.conf
#	sysctl -p
#PREROUTING是目的地址转换，要把别人的公网IP换成你们内部的IP，才让访问到你们内部受防火墙保护的机器。
#	iptables -t nat -A PREROUTING -p tcp -m tcp -d 58.211.82.13 --dport 80 -j DNAT --to-destination 192.168.77.21:80
#POSTROUTING是源地址转换，要把你的内网地址转换成公网地址才能让你上网。
#	iptables -t nat -A POSTROUTING -p tcp -m tcp -s192.168.77.21 --dport 80 -j SNAT --to-source 58.211.82.13:80
#	iptables -t nat -A POSTROUTING -s 10.8.0.0/255.255.255.0 -o eth0 -j SNAT --to-source 192.168.5.3-192.168.5.5
#	MASQUERADE动态获取出去的地址，一般网关服务器
#	iptables -t nat -A POSTROUTING -j MASQUERADE


#系统常用端口开启
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT -j ACCEPT
iptables -P FORWARD -j REJECT

#防Spoofing（伪造内网IP）攻击
#iptables -t filter -A INPUT -i $EXTERNAL_ -s $INTERNAL_NET -j DROP
#防服务器敏感信息扫描
#iptables -t filter -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
#iptables -t filter -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
#iptables -t filter -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP

#iptables日志开启
#	iptables -A INPUT -j LOG --log-prefix "IPTABLES INPUT: " --log-level warn
#	iptables -A FORWARD -j LOG --log-prefix "IPTABLES FORWARD: " --log-level warn
#	iptables -A OUTPUT -j LOG --log-prefix "IPTABLES OUTPUT: " --log-level warn
#	

#保存规则
/etc/init.d/iptables save
