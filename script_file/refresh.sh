#!/bin/bash
#!/bin/bash

if [ -z $1 ];then
	echo "请输入参数"
	exit
fi


check_ver() {
	echo $1 | grep -Eq '[0-9]{14}$'
	if [ $? -ne 0 ];then
		echo "请输入正确的参数版本号"
		exit
	fi
}


varnish_id=$(date +%Y%m%d%H%M%S)
varnish="/usr/local/varnish/sbin/varnishd"
varnishadm="/usr/local/varnish/bin/varnishadm"
prog=$(basename $varnish)
VARNISH_CONF_FILE="/usr/local/varnish/vcl.conf"
PID=$(pgrep varnish)
myPid=$$
start_jobs() {
	$varnish \
	-n /var/vcache \
	-u www \
	-g www \
	-w 2,65536,60 \
	-a :80 \
	-f $VARNISH_CONF_FILE \
	-T 127.0.0.1:8080 \
	-s file,/var/vcache/varnish_cache.data,50G \
	-p thread_pool_min=200 \
	-p thread_pool_max=4000 \
	-p thread_pools=4 \
	-p thread_pool_add_delay=2 \
	-p listen_depth=4096 \
	-p lru_interval=86400
}


start_check() {
	[ -x $varnish ] || exit 5
	[ -f $VARNISH_CONF_FILE ] || exit 6
	if [ "$PID" ==  "$myPid" ] || [ -z "$PID" ];then
		echo $"Starting $prog: OK"
		start_jobs
	else
		echo "already running : $PID"
	fi
}


stop_check() {
	[ -x $varnish ] || exit 5
	[ -f $VARNISH_CONF_FILE ] || exit 6
	if [ -z "$PID" ];then
		echo $"$prog not running"
	else
		ret=$(pkill varnishd)
		echo $ret
	fi
}


purgehost_check() {
	[ -x $varnishadm ] || exit 5
	if [ $# > 0 ];then
		$varnishadm -T localhost:8080 ban req.http.host == $1 
		echo "purged $1"
	fi
}


purge_check() {
	[ -x $varnishadm ] || exit 5
	if [ $# > 0 ];then
		$varnishadm -T localhost:8080 ban.url $1 
		echo "purged $1"
	fi
}
check_reload(){
	[ -x $varnishadm ] || exit 5
	[ -f $VARNISH_CONF_FILE ] || exit 6
	if [ -z "$PID" ];then
		echo $"$prog not running"
	else
		$varnishadm -T localhost:8080 vcl.load $varnish_id $VARNISH_CONF_FILE
		if [ $? -eq 0 ];then
			$varnishadm -T localhost:8080 vcl.use $varnish_id
			echo $"Check $prog : OK "
		else
			echo $"Check $prog Fail: "
		fi
	fi


}


check_list() {
	if [ -z "$PID" ];then
		echo $"$prog not running"
	else
		$varnishadm -T localhost:8080 vcl.list
	fi
}


check_reback() {
	check_ver $1
	if [ $? -eq 0 ];then
		if [ -z "$PID" ];then
			echo $"$prog not running"
		else
			$varnishadm -T localhost:8080 vcl.use $1
		fi
		echo $"$prog Version Back $1"
	fi
}


case "$1" in
	start)
		start_check && exit 0
		$1
	;;
	stop)
		stop_check && exit 0
		$1
	;;
	purgehost)
		purgehost_check $2  && exit 0
		$1
	;;
	purge)
		purge_check $2  && exit 0
		$1
	;;
	reload)
		check_reload && exit 7
		$1
	;;
	list)
		check_list && exit 0
		$1
	;;
	reback)
		check_reback $2 && exit 0
		$1
	;;
	*)
		echo $"Usage: $0 {start|stop|reload|purge|purgehost|list|reback}"
		exit 2
esac
