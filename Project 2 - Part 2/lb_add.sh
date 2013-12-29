##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script adds server to HAproxy (load balancer)
#
##################################################################
#!/bin/bash
id=$1
ip=$2
info=/users/vshahane/data/$id
/users/vshahane/scripts/list_instances.sh $ip

iip=`head -1 $info`
echo "server $id $iip:8080 check inter 5000" >> /users/vshahane/scripts/haproxy.cfg
/users/vshahane/scripts/haproxy_dynamic_add_remove /users/vshahane/scripts/haproxy.cfg
