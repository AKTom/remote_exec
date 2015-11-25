# -*- coding: UTF-8 -*-
#__author__ = 'li90.com'
import paramiko
import os,sys

def ssh(ip,port,user,passwd,cmd):  
    client = paramiko.SSHClient()  
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
    try:
       client.connect(ip, port, user, passwd, timeout=20)  
       stdin, stdout, stderr = client.exec_command(cmd)  
       for line in stdout:  
           print "\033[36;1m%-18s-->>  \033[0m" %ip +line.strip('\n')  
    except Exception,e:
        print "\033[31;1m%-18s%s:%s\033[0m" % (ip,e.__class__, e)
    client.close()  

#=============================

def sshChannel(ip,port,user,passwd,cmd,rootpd):  
    passinfo = 'Password: '
    client = paramiko.SSHClient()  
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
    try:
       client.connect(ip, port, user, passwd, timeout=20)  

       channel = client.invoke_shell()
       channel.settimeout(10)

       resp = ''
       channel.send('su -\n')
       buff = ''
       while not buff.endswith(passinfo):
           try:
              resp = channel.recv(9999)
           except Exception,e:
              print '\n\033[31;1m%-18sError info:%s connection time.\033[0m' % (ip,str(e))
              channel.close()
              client.close()
              sys.exit()
           buff +=resp

       channel.send(rootpd+'\n')
       buff = ''
       while not buff.endswith('# '):
           resp = channel.recv(9999)
           if not resp.find('$ ')==-1:
              print '\n\033[31;1m%-18sError info: (Super)Authentincation failed.\033[0m' % (ip)
              channel.close()
              client.close()
              sys.exit()
           buff +=resp

       channel.send(cmd+'\n')
       buff = ''
       resp = ''
       try:
           while not buff.endswith('# '):
              resp = channel.recv(9999)
              buff +=resp
       except Exception, e:
           print "\n\033[31;1m%-18s%s:%s\033[0m" % (ip,e.__class__, e)
       print "\n\033[36;1m%-18s-->>  \033[0m" %ip +buff.strip('\n')
       channel.close()
       client.close()
    except Exception,e:
        print "\n\033[31;1m%-18s%s:%s\033[0m" % (ip,e.__class__, e)
    client.close() 
