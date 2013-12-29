##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script collects used server count over period
#
##################################################################
#!/bin/bash
logfile=/var/log/haproxy.log
countlog=/users/vshahane/data/servercount.log
>$countlog
usage_pool=/users/vshahane/data/usage_pool.lst
while :; do
used=`cat $usage_pool | wc -l`
dt=`date +%s`
awk -vUSED="$used" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
sleep 1
done
