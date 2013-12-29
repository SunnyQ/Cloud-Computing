##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script monitors the performance of load splitter (haproxy)
#
##################################################################
#!/bin/bash
logfile=/var/log/haproxy.log
metricslog=/users/vshahane/data/metrics.log
>$metricslog
template=$1
target=`cat $template | grep "Response-time" | awk '{print $3}'`
targetms=$(($target*1000))
echo "Starting performance monitoring for HTTP response in background............."
echo "Taget response time $target s, $targetms ms..................."
sudo logtail -f $logfile > /dev/null
while :; do
avg=`sudo logtail -f $logfile | awk '$10 == 200 {print $12,$13 }' | awk '{sum+=$2} END { if (NR >0) print sum/NR; else print 0;}'`
dt=`date +%s`
load=`awk -vAVG="$avg" -vDT="$dt" 'BEGIN { printf "%d %d", DT, AVG }'`
echo $load >> $metricslog
avg=`echo $load | awk '{print $2}'`
if [ $avg -gt $targetms ]; then
	echo "Response time higher than target............trying to add new server to cluster............"
	/users/vshahane/scripts/add_server_to_lb.sh $template
else
	echo "Response time lower than target.............will remove any additional servers from cluster........."
	/users/vshahane/scripts/delete_server_from_lb.sh $template
fi
sleep 5
done
