#!/bin/bash
HOME=/usr/local/nginx
nginx=${HOME}/sbin/nginx
$nginx -t
if [ $? -ne 0 ];then
	echo -e "\033[31;1mtest failed!!!\033[0m"
	exit 1
else
	echo -e "\033[32;1msyntax is ok~~~\033[0m"
	echo -e "\033[32;1mReload the configuration file...\033[0m"
	$nginx -s reload
	if [ $? -ne 0 ];then
		echo -e "\033[31;1mReload failed!!!As soon as possible to deal with!!!\033[0m"
	else
		echo -e "\033[32;1m---------- OK~~~\033[0m"
	fi
fi
