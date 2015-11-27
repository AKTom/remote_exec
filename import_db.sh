#!/bin/bash
USERNAME="tools"
PASSWORD="123456"
DBNAME="tools" #要创建的数据库的库名称
TABLENAME="tool_ip" #要创建的数据库的表的名称
file="./tool_ip.txt"

MYSQL_CMD="mysql -u${USERNAME} -p${PASSWORD}"

read -p "Do you want to clean up the $DBNAME.$TABLENAME?y " -e input
if [ "$input" == 'y' ];then
	delete_sql="DELETE FROM $TABLENAME"
	echo ${delete_sql}|${MYSQL_CMD} ${DBNAME}
fi


#1\如果指定local关键词，则表明从客户主机读文件。如果local没指定，文件必须位于服务器上。
#2\如果你指定关键词low_priority，那么MySQL将会等到没有其他人读这个表的时候，才把插入数据。
#3\replace和ignore关键词控制对现有的唯一键记录的重复的处理。如果你指定replace，新行将代替有相同的唯一键值的现有行。如果你指定ignore，跳过有唯一键的现有行的重复行的输入。如果你不指定任何一个选项，当找到重复键时，出现一个错误，并且文本文件的余下部分被忽略。
#fields关键字指定了文件记段的分割格式:
#	terminated by分隔符：意思是以什么字符作为分隔符
#	
#特殊字段处理例句如下，如下句将password字段进行加密处理：
#import_table_sql="load data local infile '${file}' replace into table tool_ip fields terminated by '\t'(ip,hostname,port,username,password) set password=password('password');"
#import_table_sql="load data local infile '${file}' replace into table tool_ip fields terminated by '\t'(ip,hostname,port,username,password) set password=aes_encrypt(password,'password');"
#import_table_sql="load data local infile '${file}' replace into table tool_ip fields terminated by '\t';"
#echo ${import_table_sql}|${MYSQL_CMD} ${DBNAME}
mysqlimport -u${USERNAME} -p${PASSWORD} --local --fields-terminated-by="\t" ${DBNAME} ${file}
if [ $? -ne 0 ] #判断是否导入成功
then
        echo "import  table ${DBNAME}.${TABLENAME}  \033[31;1mfailed \033[0m ..."
        exit 1
else
	echo -e "\033[32;1mYou have successfully imported data!!!\033[0m"
fi
