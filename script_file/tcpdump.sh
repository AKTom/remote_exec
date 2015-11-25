#!/bin/bash
eth=$1
#local_ip=`ip a|awk -F"[ /]+" '{if($0~/inet/ && $0 !~/127.0.0.1/ && $0 !~/inet6/){print $3}}'`
tcpdump -i $eth -tvnn -s 0 udp or tcp > /tmp/tcpdump_temp 2>&1 &
sleep 300
killall tcpdump

awk -F'[ :]+' '{if ($0 ~/^IP.*[0-9]+\)/){$0="\n"$0}{printf $0}}' /tmp/tcpdump_temp 1<> /tmp/tcpdump_temp

cat /tmp/tcpdump_temp |sed -e 's/.*, length:* \(.*\))/\1/g' |awk -F'[ .:]+' '{print $2"."$3"."$4"."$5" => "$8"."$9"."$10"."$11"==="$1}'|sed -s 's/)//g' |tee /tmp/tcpdump.log
awk -F'===' '{a[$1]+=$2}END{for(i in a) print i,"==="a[i]}' /tmp/tcpdump.log |awk -F'===' '{print $2/300/1024" KB/s === "$1}'|sort -rn|more
