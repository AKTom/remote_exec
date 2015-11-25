#!/bin/bash
read -p "Do you want to which nic binding? " -e wangka
wangka1=`echo "/etc/sysconfig/network-scripts/ifcfg-${wangka}"`
wangka2=`echo "/etc/sysconfig/network-scripts/ifcfg-${wangka}:0"`
cp -a $wangka1 $wangka2
#DEVICE

sed -i 's/^UUID/#UUID/g' $wangka2
sed -i 's/^NM_CONTROLLED/#NM_CONTROLLED/g' $wangka2
read -p 'input your ipaddr: ' -e ip

if [ -n "$ip" ];then
	sed -i 's/^IPADDR.*$/IPADDR='''$ip'''/g' $wangka2
else
	echo -e "\033[31;1mipaddress cannot be empty\033[0m"
fi

echo -e "\033[35;1mIf you don't want to set the gateway,press ENTER\033[0m"
read -p 'input your gateway: ' -e gateway

if [ -n "$gateway" ];then
	sed -i 's/^GATEWAY.*$/GATEWAY='''$gateway'''/g' $wangka2
else
	echo -e "\033[31;1myour gateway empty\033[0m"
fi
