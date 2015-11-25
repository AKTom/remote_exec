#!/bin/bash
url6="http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm -U"
url5="http://repo.zabbix.com/zabbix/2.2/rhel/5/x86_64/zabbix-release-2.2-1.el5.noarch.rpm -U"
server_ip='61.155.137.242'

#判断操作系统版本
if [ -n "$(cat /etc/redhat-release|grep '6.')" ];then
	os_version=6
elif [ -n "$(cat /etc/redhat-release|grep '5.')" ];then
	os_version=5
elif [ -n "$(cat /etc/issue|grep '6.')" ];then
	os_version=6
elif [ -n "$(cat /etc/issue|grep '5.')" ];then
	os_version=5
else
	echo "Operating system version not found"
	exit 1
fi

#添加zabbix源
echo -e "\033[32;1mos_version=$os_version\033[0m"
if [[ $os_version -eq 6 ]];then
	echo "$(rpm -Uvh $url6)"
elif [[ $os_version -eq 5 ]];then
	echo "$(rpm -Uvh $url5)"
else
	echo "add zabbix_source failed"
	exit 1
fi
#安装Zabbix_agent
echo -e "\033[32;1m$(rpm -qa |grep zabbix-release)\033[0m"
yum install zabbix-agent -y
#if [ $? -ne 0 ] #判断是否安装成功
#then
#	echo "Installation Failed..."
#	exit 1
#fi
#修改配置文件
echo -e "\033[32;1m$(rpm -qa |grep zabbix-agent)\033[0m"

sed -i 's/^Server=.*$/Server='''$server_ip'''/g' /etc/zabbix/zabbix_agentd.conf
echo -e "\033[32;1m$(grep -n '^Server=' /etc/zabbix/zabbix_agentd.conf)\033[0m"

sed -i 's/^ServerActive=.*$/ServerActive='''$server_ip'''/g' /etc/zabbix/zabbix_agentd.conf
echo -e "\033[32;1m$(grep -n '^ServerActive=' /etc/zabbix/zabbix_agentd.conf)\033[0m"
#添加防火墙规则
iptables -A INPUT -p tcp -s ${server_ip} --dport 10050:10051 -m state --state RELATED,ESTABLISHED -j ACCEPT
echo "$(/etc/init.d/iptables save)"
#启动
echo "$(/etc/init.d/zabbix-agent start)"
chkconfig zabbix-agent on
echo -e "\033[32;1m$(chkconfig --list |grep zabbix-agent)\033[0m"
