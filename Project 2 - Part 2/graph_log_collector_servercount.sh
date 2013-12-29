##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script collect server counts log for graph generation
#
##################################################################
#!/bin/bash
icountlog=/users/vshahane/data/servercount.log
ocountlog=/users/vshahane/data/plot/servercount.log

>$ocountlog

while :; do

tail -fn0 $icountlog | \
while read line ; do
        echo $line >> $ocountlog
done

done
