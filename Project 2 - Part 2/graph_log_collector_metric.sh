##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script collects metric log for graph generation
#
##################################################################
#!/bin/bash
imetricslog=/users/vshahane/data/metrics.log
ometricslog=/users/vshahane/data/plot/metrics.log

>$ometricslog

while :; do

tail -fn0 $imetricslog | \
while read line ; do
        echo $line >> $ometricslog
done

done
