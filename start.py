#!/usr/bin/env python
# -*- coding: UTF-8 -*-
#__author__ = 'li90.com'
import threading
import mysql_conn
import sqlite3_conn
import ssh_cmd
import sys
import getpass
import scp_cmd
import tab
def whichColumn(likeString):
    for likeColumn in ('ip','hostname','mark'):
        n.query('ip','tool_ip',likeColumn,likeString)
        if n.fetchall():
            return likeColumn
            break
def startThread(data,TARGET,ARGS):
    res_list=[]
    for a in data:
        args_1=(a['ip'],int(a['port']),a['username'],a['password'])
        args_2=list(args_1)
        for i in list(ARGS):
            if not i:continue
            args_2.append(i)
        args=tuple(args_2)
        th=threading.Thread(target=TARGET,args=args)
        res_list.append(th)
        th.start()
    for th in res_list:
        th.join()
    print "\033[35;1mThis task is complete!!!\033[0m"
def cmdInput(function,otherArgs=''):
    print 'Now you can execute \033[32;1mShell\033[0m Commands...'
    cmd=''
    if not otherArgs:Prompt='$'
    else:Prompt='#'
    while True:
        tmp=''
        tmp=raw_input('\033[33;1mYour command ]\033[0m'+Prompt+' ').strip()
        if not tmp:continue
        elif (tmp=='q' or tmp=='quit' or tmp=='exit'):
            print "You quit the command mode"
            break
        elif (tmp != 'end'):
           cmd +=tmp + '\n'
           continue
        startThread(data,function,(cmd,otherArgs))
        cmd=''
def transfer():
    print 'Upload file ready...'
    while 1:
        local_dir=raw_input('\033[33;1mlocal directory \033[0m').strip()
        if not local_dir:continue
        if (local_dir=='q' or local_dir=='quit' or local_dir=='exit'):
            print "You give up the transfer files"
            break
        remote_dir=raw_input('\033[33;1mremote directory \033[0m').strip()
        while not remote_dir:remote_dir=raw_input('\033[33;1mremote directory \033[0m').strip()
        if (remote_dir=='q' or remote_dir=='quit' or remote_dir=='exit'):
            print "You give up the transfer files"
            break
        f=raw_input('\033[33;1mfile name  \033[0m').strip()
        while not f:f=raw_input('\033[33;1mfile name \033[0m').strip()
        if (f=='q' or f=='quit' or f=='exit'):
            print "You give up the transfer files"
            break
        startThread(data,scp_cmd.scp,(f,local_dir,remote_dir,))
        continue
def getHost():
    while 1:
        hostInput=(raw_input('\033[32;1mYour host(s) \033[0m').strip()).split(',')
        if hostInput[0]=='':continue
        if (str(hostInput[0])=='q' or str(hostInput[0])=='quit' or str(hostInput[0])=='exit'):
            print "Program has quit"
            sys.exit()
        else:
            for HOST in hostInput:
                column=whichColumn(HOST)
                if column is None:
                    print "\033[31;1m%s is not exist\033[0m" %(HOST)
                    continue
                print "Match: \033[35;1m%s \033[0mlike \033[35;1m%s \033[0m ..." %(column,HOST)
                n.query('*','tool_ip',column,HOST)
                tmpData=list(n.fetchall())
                for tmp in tmpData:
                    data.append(tmp)
        return data
def man():
    for ip_list in data:
        print ip_list["ip"]
    option=''
    while 1:
        option=raw_input('\033[32;1m1\033[0m-Command\n\033[32;1m2\033[0m-Super Command\n\033[32;1m3\033[0m-Uploadfile\n\033[32;1mPlease choose 1,2 or 3... \033[0m').strip()
        if not option:continue
        if (option=='q' or option=='quit' or option=='exit'):
            break
        if option=='1':
            cmdInput(ssh_cmd.ssh)
        if option=='2':
            rootpd=''
            while not rootpd:rootpd=getpass.getpass('Enter Super password: ')
            cmdInput(ssh_cmd.sshChannel,rootpd)
        if option=='3':
            transfer()
if __name__ == '__main__':
    #	mysql
#    n=mysql_conn.MySQL('localhost','tools','123456')
#    n.selectDb('tools')
    #	sqlite3
    reload(sys)
    sys.setdefaultencoding('utf-8')
    n=sqlite3_conn.SQLite('/Users/meilinli/360云盘/python小脚本/newproject/tools.db')
    while 1:
        data=[]
        getHost()
        if data!=[]:man()
