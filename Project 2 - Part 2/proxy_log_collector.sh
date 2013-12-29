##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script parses & stores HAproxy log in required format
#
##################################################################
#!/bin/bash
logfile=/var/log/haproxy.log
proxylog=/users/vshahane/data/proxy.log
>$proxylog
while :; do
tail -fn0 $logfile | \
while read line ; do
	echo $line | awk '$10 == 200 {print $12,$13 }' >> $proxylog
done
done
