##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script removes server from HAproxy (load balancer)
#
##################################################################
#!/bin/bash
id=$1
temp=/users/vshahane/data/temp.tmp
grep -v $id /users/vshahane/scripts/haproxy.cfg > $temp && mv $temp /users/vshahane/scripts/haproxy.cfg
/users/vshahane/scripts/haproxy_dynamic_add_remove /users/vshahane/scripts/haproxy.cfg
