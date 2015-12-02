#!/bin/bash
#exec 2|install.log
#exec 1|install.log

ROOT_password="" #如果mysql的root用户原先有密码，请添加上自己的密码
USERNAME="tools" #新建mysql用户
PASSWORD="123456" #新建mysql用户密码
DBNAME="tools" #要创建的数据库的库名称，尽量别修改
TABLENAME="tool_ip" #要创建的数据库的表的名称，尽量别修改

echo "***********************************"
echo -e "\033[30;1mStart the installation depends on the environment...\033[0m"
#for i in python python-paramiko mysql mysql-server MySQL-python;do
#	if [ -n "$(rpm -qa|grep  $i)" ] > /dev/null
#	then
#		echo -e "\033[32;1m$i was installed\033[0m"
#	else
#		echo -e "\033[31;1m$i is not installed\033[0m"
#		yum install $i -y
#		echo -e "\033[32;1m$i installed successfully\033[0m"
#	fi
#done
brew list|grep mysql &&echo -e "\033[32;1mmysql was installed\033[0m" ||brew install mysql
for i in paramiko MySQL-python:do
	pip list |grep $i &&echo -e "\033[32;1m$i was installed\033[0m" ||pip install $i
do
echo "***********************************"
echo -e "\033[30;1mBegan to initialize the mysql...\033[0m"
if [ -n "$(ps -ef |grep mysql|grep -v grep)" ];then
	echo -e "\033[32;1mmysql is running....\033[0m"
else
	mysql.server start
fi
if [ -z $ROOT_password ];then
	CMD="mysql -uroot"
else
	CMD="mysql -uroot -p${ROOT_password}"
fi
echo "create database ${DBNAME}" 
create_db_sql="create database IF NOT EXISTS ${DBNAME}"
echo ${create_db_sql}  | ${CMD}   #创建数据库                   
if [ $? -ne 0 ] #判断是否创建成功
then
 echo -e "create databases ${DBNAME} \033[31;1mfailed \033[0m..." 
 exit 1
fi
echo "create user ${USERNAME}" 
create_user_sql=" CREATE USER '${USERNAME}'@'${HOSTNAME}' IDENTIFIED BY '${PASSWORD}';"
echo ${create_db_sql}  | ${CMD}   #创建用户                   
if [ $? -ne 0 ] #判断是否创建成功
then
 echo "create user ${USERNAME} \033[31;1mfailed \033[0m ..." 
 exit 1
fi
echo $(${CMD} -e "GRANT ALL ON ${DBNAME}.* TO '${USERNAME}'@'localhost' IDENTIFIED BY '${PASSWORD}'; ") 
if [ $? -ne 0 ] #判断是否创建成功
then
 echo "GRANT \033[31;1mfailed \033[0m ..." 
 exit 1
fi

MYSQL_CMD="mysql -u${USERNAME} -p${PASSWORD}"
echo "create table ${TABLENAME}" 
create_table_sql="create table IF NOT EXISTS ${TABLENAME}(
ip varchar(20) not null unique,
hostname varchar(20) not null,
port varchar(20) not null default 22,
username varchar(20) not null,
password varchar(20) not null,
mark varchar(20),
PRIMARY KEY (ip)
)ENGINE=MyISAM DEFAULT CHARSET=latin1"
echo ${create_table_sql}|${MYSQL_CMD} ${DBNAME}   #在给定的DB上，创建表
if [ $? -ne 0 ] #判断是否创建成功
then
	echo "create  table ${DBNAME}.${TABLENAME}  \033[31;1mfailed \033[0m ..." 
	exit 1
fi
echo -e "Do you need to import the data ?"
read -p 'Please input data file, or "Enter"  ' -e input
if [ -n "$input" ];then
	sh $input
else
	exit 1
fi
