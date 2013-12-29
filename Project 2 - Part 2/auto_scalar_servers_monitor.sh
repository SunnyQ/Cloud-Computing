##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script monitors individual servers/vms in use (using ping)
#
##################################################################
#!/bin/bash
template=$1
t1=/users/vshahane/data/t1.tmp
usage_pool=/users/vshahane/data/usage_pool.lst
countlog=/users/vshahane/data/servercount.log
ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
source /users/vshahane/scripts/list_instances.sh $ip
echo "Starting monitoring of servers in use in background................."
while :; do
while read i; do
id=$i
info=/users/vshahane/data/$id
iip=`head -1 $info`
echo "Checking status of server........$iip"
st=`ping -c5 $iip | grep 'received' | awk -F',' '{ print $2}' | awk '{ print $1}'`
if [ $st -le 0 ]; then
	echo "Server $id ($iip) appears to be down........removing from cluster configuration"
	used=`cat $usage_pool | wc -l`
	dt=`date +%s`
	awk -vUSED="$used" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
	
	echo "Removing server from usage pool.........."
	grep -v $id $usage_pool > $t1 && mv $t1 $usage_pool
	echo "Removing server from load balancer.........."
	/users/vshahane/scripts/lb_delete.sh $id
	echo "Deleting server image................."
	/users/vshahane/scripts/delete_server.sh $id $ip

	echo "Adding new server to cluster if required..............."
	/users/vshahane/scripts/add_server_to_lb.sh $template

	used=`cat $usage_pool | wc -l`
        dt=`date +%s`
        awk -vUSED="$used" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
else 
	echo "Server $id ($iip) is online............"
	
fi
done < $usage_pool
sleep 5
done
