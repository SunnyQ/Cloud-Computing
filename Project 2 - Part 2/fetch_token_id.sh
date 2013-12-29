##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script fetches authentication tokens from keystone
#
##################################################################
#!/bin/bash
ip=$1
link=http://${ip}:35357/v2.0/tokens
tokenfile=/users/vshahane/data/token_id
tenantfile=/users/vshahane/data/tenant_id
curl $link -X POST -H "Content-Type: application/json" -d '{"auth": {"tenantName": "demo", "passwordCredentials": {"username": "admin", "password": "123"}}}' | python -mjson.tool | /bin/jshon -e access | /bin/jshon -e token | /bin/jshon -e id | sed -e 's/^"//'  -e 's/"$//' > $tokenfile
curl $link -X POST -H "Content-Type: application/json" -d '{"auth": {"tenantName": "demo", "passwordCredentials": {"username": "admin", "password": "123"}}}' | python -mjson.tool | /bin/jshon -e access | /bin/jshon -e token | /bin/jshon -e tenant | /bin/jshon -e id | sed -e 's/^"//'  -e 's/"$//' > $tenantfile
