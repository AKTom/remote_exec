#!/usr/bin/env python
import psutil
a=psutil.virtual_memory()
print "total: %s M\tavailable: %s M\tpercent: %s  \t\tused: %s M\nfree: %s M\tactive: %s M\t\tinactive: %s M\t\twired: %s M" % (int(a[0])/1024/1024,int(a[1])/1024/1024,a[2],int(a[3])/1024/1024,int(a[4])/1024/1024,int(a[5])/1024/1024,int(a[6])/1024/1024,int(a[7])/1024/1024)


