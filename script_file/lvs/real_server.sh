#!/bin/bash 
# 
# Script to start LVS DR real server.
# description: LVS DR real server
#
VIP=192.168.30.149
BROADCAST=192.168.30.255 #vip's broadcast
host=`/bin/hostname`

Usage ()
{
  echo "Usage:`basename $0` (start|stop|status)"
  exit 1
}

if [ $# -ne 1 ];then
  Usage
fi

chmod 755 /etc/rc.d/init.d/functions
. /etc/rc.d/init.d/functions
case "$1" in
	start)
		# Start LVS-DR real server on this machine.
		echo "reparing for Real Server"
		echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
		echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
		echo "1" >/proc/sys/net/ipv4/conf/eth0/arp_ignore
		echo "2" >/proc/sys/net/ipv4/conf/eth0/arp_announce
		/sbin/ifconfig lo:0 $VIP netmask 255.255.255.255 broadcast $BROADCAST up
		/sbin/route add -host $VIP dev lo:0
	;;
	stop)
		# Stop LVS-DR real server loopback device(s).
		/sbin/ifconfig lo:0 down
		echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
		echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
		echo "0" >/proc/sys/net/ipv4/conf/eth0/arp_ignore
		echo "0" >/proc/sys/net/ipv4/conf/eth0/arp_announce
		echo "stop Real Server"
	;;
	status)
		#Status of LVS-DR real server. 
		islothere=`/sbin/ifconfig lo:0|grep $VIP`
		isrothere=`netstat -rn|grep "lo:0|grep $VIP"`
		if [ ! -z "$islothere" -o ! -z "$isrothere" ];then
			echo "LVS-DR real server Running"
		else
			echo "LVS-DR real server Stopped"
		fi
	;;
	*)
		# Invalid entry.
		Usage
	;;
esac
