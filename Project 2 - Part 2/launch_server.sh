##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script launches nova instance
#
##################################################################
#!/bin/bash
t1=/users/vshahane/data/create_instance.sh
t2=/users/vshahane/data/create_instance.tmp

vmimage=$1
ip=$2

echo \#\!\/bin\/bash > $t1
echo \/bin\/tcsh -c \"\/usr\/local\/bin\/nova --os-username=admin --os-password=123 --os-tenant-name=demo --os_auth_url=http\:\/\/$ip\:5000\/v2.0\/ --os-region-name=RegionOne boot --image=$vmimage --flavor=2 serverX --meta description=\'extra server\' --key_name=mykey --security-groups=mygroup\" >> $t1

chmod 700 $t1
$t1 > $t2

cat $t2 | grep -w "id " | awk '{print $4}'

rm $t1
rm $t2
