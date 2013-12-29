##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script collects HAproxy log for graph generation
#
##################################################################
#!/bin/bash
iproxylog=/users/vshahane/data/proxy.log
oproxylog=/users/vshahane/data/plot/proxy.log

>$oproxylog

while :; do

tail -fn0 $iproxylog | \
while read line ; do
	echo $line >> $oproxylog
done

done
