##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script fetches information for all instances in directory
#
##################################################################
#!/bin/bash
ip=$1
dir=/users/vshahane/data/
t1=/users/vshahane/data/id_list.tmp
t2=/users/vshahane/data/temp2.tmp
t3=/users/vshahane/data/temp3.tmp
tokenfile=/users/vshahane/data/token_id
tenantfile=/users/vshahane/data/tenant_id
token=`cat $tokenfile`
tenant=`cat $tenantfile`
link=http://${ip}:8774/v2/${tenant}/servers
cd $dir

curl -s $link -X GET -H "X-Auth-Project-Id: admin" -H "Accept: application/json" -H "X-Auth-Token: $token" | python -mjson.tool | /bin/jshon -e servers | /bin/jshon -a -e id -u > $t1

while read i; do
link=http://${ip}:8774/v2/${tenant}/servers/${i}
curl -s $link -X GET -H "X-Auth-Project-Id: admin" -H "Accept: application/json" -H "X-Auth-Token: $token" | python -mjson.tool | /bin/jshon -e server | /bin/jshon -e addresses | /bin/jshon -e private | /bin/jshon -a -e addr -u > $t2
curl -s $link -X GET -H "X-Auth-Project-Id: admin" -H "Accept: application/json" -H "X-Auth-Token: $token" | python -mjson.tool | /bin/jshon -e server | /bin/jshon -e name | sed -e 's/^"//'  -e 's/"$//' > $t3
cat $t2 $t3 > $dir/$i
done < $t1

rm $t1
rm $t2
rm $t3
