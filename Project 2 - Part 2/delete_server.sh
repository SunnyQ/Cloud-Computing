##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script deletes server from openstack (nova/compute)
#
##################################################################
#!/bin/bash
t1=/users/vshahane/data/delete_server.sh

id=$1
ip=$2

echo \#\!\/bin\/bash > $t1
echo \/bin\/tcsh -c \"\/usr\/local\/bin\/nova --os-username=admin --os-password=123 --os-tenant-name=demo --os_auth_url=http\:\/\/$ip\:5000\/v2.0\/ --os-region-name=RegionOne delete $id\" >> $t1

chmod 700 $t1
$t1

rm $t1
