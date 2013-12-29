##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script instantiates template
#
##################################################################
#!/bin/bash
t1=/users/vshahane/data/create_instance.sh
t2=/users/vshahane/data/create_instance.tmp

ip=$2
file=$1
max=`cat $file | grep "Max VMs" | awk '{print $3}'`
min=`cat $file | grep "Min VMs" | awk '{print $3}'`
vmimage=`cat $file | grep "VM image" | awk '{print $3}'`

launchcount=`expr $min + 1`

while [ $launchcount -gt 0 ]
do

echo \#\!\/bin\/bash > $t1
echo \/bin\/tcsh -c \"\/usr\/local\/bin\/nova --os-username=admin --os-password=123 --os-tenant-name=demo --os_auth_url=http\:\/\/$ip\:5000\/v2.0\/ --os-region-name=RegionOne boot --image=$vmimage --flavor=2 server$launchcount --meta description=\'server$launchcount\' --key_name=mykey --security-groups=mygroup\" >> $t1

chmod 700 $t1
$t1 > $t2

cat $t2 | grep -w "id " | awk '{print $4}'

launchcount=$(( $launchcount - 1 ))
done
