##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script executes the different functions for auto scalar
# it is invoked from management console
#
##################################################################
#!/bin/bash
usage() {
  echo "USAGE: autoscalar: [options]
  \"-i template name/path\" - Instantiates cluster as per given template
  \"-d\" - Destroy cluster
  \"-h\" - print this usage message
  \"-s\" - Start data collection for generating graph (Use at the start of the load)
  \"-g\" - Generate graph from data collected (Use at the end of load test)
  \"-e\" - Exit from the auto scalar server prompt"
}
ip=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
t1=/users/vshahane/data/t1.tmp

args=$(getopt -l "autoscalar:" -o "i:dhsge" -- "$@")
eval set -- "$args"

while [ $# -ge 1 ]; do

case "$1" in
-i)
template="$2"
free_pool=/users/vshahane/data/free_pool.lst
usage_pool=/users/vshahane/data/usage_pool.lst
echo "Instantiating cluster from $template"
max=`cat $template | grep "Max VMs" | awk '{print $3}'`
min=`cat $template | grep "Min VMs" | awk '{print $3}'`
i=$min
echo "Minimum servers to launch: $i"
echo "Fetching authentication tokens........"
source /users/vshahane/scripts/fetch_token_id.sh $ip
echo "Launching servers"
source /users/vshahane/scripts/instantiate_template.sh $template $ip > $free_pool

echo "Sleeping.........."
sleep 60
/users/vshahane/scripts/list_instances.sh $ip
while [ $i -gt 0 ]
do
echo "Taking server from free pool........."
id=`head -1 $free_pool`
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

sleep 600

#while :; do
#echo "Checking if web service online..........http://$iip:8080/webserver"
#url="http://$iip:8080"
#response=$(curl --write-out %{http_code} --silent --output /dev/null ${url})
#if [ $response -eq 200 ]; then
#	echo "URL online: $url, response code:$response"
#	break
#else
#	echo "URL not online: $url, response code:$response"
#fi
#echo "Sleeping......."
#sleep 30
#done

echo "Adding server to load balancer..........."
/users/vshahane/scripts/lb_add.sh $id $ip
echo "Removing server from free pool.........."
grep -v $id $free_pool > $t1 && mv $t1 $free_pool
echo "Adding server to usage pool............."
echo $id >> $usage_pool
i=$(( $i - 1 ))
done
echo "Done with launching of template.........."
echo "Starting autoscalar performance monitor..........."
/users/vshahane/scripts/auto_scalar_performance_monitor.sh $template &

echo "Starting monitoring of servers.............."
/users/vshahane/scripts/auto_scalar_servers_monitor.sh $template &

echo "Starting collection of load splitter log............."
/users/vshahane/scripts/proxy_log_collector.sh &

echo "Starting collection of server count................"
/users/vshahane/scripts/server_count_log_collector.sh &

echo "Starting colletion of server's performance................"
/users/vshahane/scripts/performance_collector_gen.sh &

shift
;;

-d)
free_pool=/users/vshahane/data/free_pool.lst
usage_pool=/users/vshahane/data/usage_pool.lst
echo "Killing any process started in background..........."
ps -ef | grep server_count_log_collector.sh  | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep proxy_log_collector.sh  | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep auto_scalar_servers_monitor.sh  | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep auto_scalar_performance_monitor.sh  | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep performance_collector.sh | awk '{print $2}' | xargs kill > /dev/null
echo "Destroying cluster........."
echo "Destroying free pool........"
while read i; do
echo "Destroying server $i........."
/users/vshahane/scripts/delete_server.sh $i $ip
rm /users/vshahane/data/$i
done < $free_pool

echo "Destroying usage  pool........"
while read i; do
echo "Removing server from load balancer........"
/users/vshahane/scripts/lb_delete.sh $i
echo "Sleeping........"
sleep 10
echo "Destroying server $i........."
/users/vshahane/scripts/delete_server.sh $i $ip
rm /users/vshahane/data/$i
done < $usage_pool
echo "Destroying pools......."
rm $free_pool
rm $usage_pool
shift
;;

-h)
usage
shift
;;

-e)
echo "Control won't come here........handled at upper level"
shift
;;

-s)
echo "Starting data collection for generation of graph.............."
/users/vshahane/scripts/graph_log_collector_proxy.sh &
/users/vshahane/scripts/graph_log_collector_servercount.sh &
/users/vshahane/scripts/graph_log_collector_metric.sh &
shift
;;

-g)
echo "Generating graphs.............."
echo "Stopping data collection for generation of graph.................."
ps -ef | grep graph_log_collector.sh | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep graph_log_collector_servercount.sh | awk '{print $2}' | xargs kill > /dev/null
ps -ef | grep graph_log_collector_metric.sh | awk '{print $2}' | xargs kill > /dev/null
sleep 3
/users/vshahane/scripts/graph_generator.sh
shift
;;

--)
usage
shift
break
;;
esac
shift
done
