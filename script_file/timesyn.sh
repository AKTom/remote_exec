#!/bin/bash
server='61.155.137.243'

echo "***********************************"
for i in ntp cronie;do
        if [ -n "$(rpm -qa|grep  $i)" ] > /dev/null
        then
                echo -e "\033[32;1m$i was installed\033[0m"
        else
                echo -e "\033[31;1m$i is not installed\033[0m"
                yum install $i -y
                echo -e "\033[32;1m$i installed successfully\033[0m"
        fi
done
echo "$(/usr/sbin/ntpdate $server)"
echo "0 4 * * * /usr/sbin/ntpdate $server">>/etc/crontab
