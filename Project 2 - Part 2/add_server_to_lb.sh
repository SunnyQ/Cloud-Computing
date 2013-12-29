############################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script adds server/vm to load balancer (HAproxy)
#
############################################################
#!/bin/bash
template=$1
t1=/users/vshahane/data/t1.tmp
countlog=/users/vshahane/data/servercount.log
ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
max=`cat $template | grep "Max VMs" | awk '{print $3}'`
min=`cat $template | grep "Min VMs" | awk '{print $3}'`
vmimage=`cat $template | grep "VM image" | awk '{print $3}'`
free_pool=/users/vshahane/data/free_pool.lst
usage_pool=/users/vshahane/data/usage_pool.lst
free=`cat $free_pool  | wc -l`
used=`cat $usage_pool | wc -l`
#echo "Free pool servers: $free"
#echo "Usage pool server: $usage"
#echo "Min/max limit for cluster: $min, $max"
if [ $used -lt $max ]; then
	echo "Adding server to cluster........"
	if [ $free -ge 1 ]; then
		use=`cat $usage_pool | wc -l`
                dt=`date +%s`
                awk -vUSED="$use" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
		
		echo "Taking server from free pool........."
		id=`tail -1 $free_pool`
		echo "Adding server to load balancer..........."
		source /users/vshahane/scripts/lb_add.sh $id $ip
		echo "Removing server from free pool.........."
		grep -v $id $free_pool > $t1 && mv $t1 $free_pool
		sleep 1
		echo "Adding server to usage pool............."
		grep -v $id $usage_pool > $t1 && mv $t1 $usage_pool
		echo $id >> $usage_pool

		use=`cat $usage_pool | wc -l`
                dt=`date +%s`
                awk -vUSED="$use" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
	else
		use=`cat $usage_pool | wc -l`
        	dt=`date +%s`
	        awk -vUSED="$use" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog

		echo "No server in free pool..............launching new server............"
		/users/vshahane/scripts/launch_server.sh $vmimage $ip >> $free_pool
		echo "Taking server from free pool........."
                id=`tail -1 $free_pool`
		/users/vshahane/scripts/list_instances.sh $ip
		info=/users/vshahane/data/$id
		iip=`head -1 $info`
		echo "Waiting until server boot finished.........."
		while :; do
			echo "Checking if server online...........$iip"
			st=`ping -c3 $iip | grep 'received' | awk -F',' '{ print $2}' | awk '{ print $1}'`
			if [ $st -gt 0 ]; then
				echo "Server online..............."
				break
			fi
			echo "Sleeping.......server not started yet......."
			sleep 30
		done

		echo "Sleeping while all service are started............"
		sleep 360

                echo "Adding server to load balancer..........."
                /users/vshahane/scripts/lb_add.sh $id $ip
                echo "Removing server from free pool.........."
                grep -v $id $free_pool > $t1 && mv $t1 $free_pool
                echo "Adding server to usage pool............."
		grep -v $id $usage_pool > $t1 && mv $t1 $usage_pool
                echo $id >> $usage_pool
		
		use=`cat $usage_pool | wc -l`
        	dt=`date +%s`
        	awk -vUSED="$use" -vDT="$dt" 'BEGIN { print DT, USED }' >> $countlog
	fi
else
	echo "Already maximum number of servers in cluster........."
fi

#free=`cat $free_pool  | wc -l`

#if [ $free -eq 0 ]; then
#	echo "No VMs in free pool.............launching one for standby.............."
#	/users/vshahane/scripts/launch_server.sh $vmimage $ip >> $free_pool		
#else
#	echo "Free pool has VM...............not creating new one................"
#fi

