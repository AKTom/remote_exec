echo -e "\033[30;1mStart the installation depends on the environment...\033[0m"
for i in httpd php epel-release php-mssql;do
        if [ -n "$(rpm -qa|grep  $i)" ] > /dev/null
        then
                echo -e "\033[32;1m$i was installed\033[0m"
        else
		if [ "$i" == epel-release ];then
                	echo -e "\033[34;1m$i is not installed\033[0m"
			rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm -U
                	echo -e "\033[32;1m$i installed successfully\033[0m"
		else
                	echo -e "\033[31;1m$i is not installed\033[0m"
              		yum install $i -y
                	echo -e "\033[32;1m$i installed successfully\033[0m"
		fi
        fi
done
if [ -n "$(ps -ef | grep http)" ] > /dev/null
then
	echo -e "\033[32;1m$(ps -ef | grep http)\033[0m"
else
	echo "$(/etc/init.d/httpd start)"
fi
chkconfig httpd on
