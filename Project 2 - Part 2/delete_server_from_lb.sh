##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script deleted server/vm from load splitter (haproxy)
#
##################################################################
#!/bin/bash
template=$1
t1=/users/vshahane/data/t1.tmp
countlog=/users/vshahane/data/servercount.log
max=`cat $template | grep "Max VMs" | awk '{print $3}'`
min=`cat $template | grep "Min VMs" | awk '{print $3}'`
free_pool=/users/vshahane/data/free_pool.lst
usage_pool=/users/vshahane/data/usage_pool.lst
free=`cat $free_pool  | wc -l`
used=`cat $usage_pool | wc -l`
#echo "Free pool servers: $free"
#echo "Usage pool server: $used"
#echo "Min/max limit for cluster: $min, $max"
if [ $used -gt $min ]; then
	used=`cat $usage_pool | wc -l`
	dt=`date +%s`
	awk -vUSED="$used" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
	
	echo "Removing server from cluster........"
	id=`tail -1 $usage_pool`
	echo "Removing server from usage pool.........."
	grep -v $id $usage_pool > $t1 && mv $t1 $usage_pool
	echo "Removing server from load balancer.........."
	source /users/vshahane/scripts/lb_delete.sh $id
	sleep 1
	echo "Adding server to free pool............"
	grep -v $id $free_pool > $t1 && mv $t1 $free_pool
	echo $id >> $free_pool

	used=`cat $usage_pool | wc -l`
        dt=`date +%s`
        awk -vUSED="$used" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
else
	echo "Already minimum number of servers in cluster........."	
fi
