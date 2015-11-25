# -*- coding: UTF-8 -*-
#__author__ = 'li90.com'
import paramiko
import os 
import datetime 
 
def scp(ip,port,user,passwd,f,local_dir,remote_dir): 
	try:
		filename = local_dir + f
		port=int(port)
		t=paramiko.Transport((ip, port))
		t.connect(username=user,password=passwd) 
		sftp=paramiko.SFTPClient.from_transport(t) 
	#	print '\033[36;1m%-15s-->>  \033[0mBegining to upload file %s' % (ip,datetime.datetime.now())
	#	print '\033[36;1m%-15s-->>  \033[0mUploading file:%s' % (ip,filename)
		sftp.put(filename,os.path.join(remote_dir,f)) 
		print '\033[36;1m%-15s-->>  \033[0m%s' % (ip,os.path.join(remote_dir,f))
		print '\033[36;1m%-15s-->>  \033[0mUpload file \033[32;1msuccess\033[0m %s' % (ip,datetime.datetime.now())
	except Exception,e:
		print "\033[31;1m%-18s%s:%s\033[0m" % (ip,e.__class__, e)
	t.close() 
