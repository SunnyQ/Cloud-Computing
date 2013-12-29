##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script generated performance monitor (at VMs), it sends
# performance data to central server (performance collector)
#
##################################################################
#!/bin/bash
script=/usr/local/src/performance_monitor.sh
sudo touch $script
sudo chown ubuntu:ubuntu $script
chmod 700 $script
echo \#\!\/bin\/bash > $script
echo \# Author - Vishal Shahane >> $script
echo \# Andrew ID - vshahane >> $script
echo \# Email ID - vshahane\@andrew.cmu.edu >>$script
echo sum_previous=0 >>$script
echo hostname=\`\/bin\/hostname\` >>$script
echo while true\; do >>$script
echo	line=\`cat \/proc\/stat \| grep \'cpu \'\` >>$script
echo	user=\`echo \$line \| awk \'\{print \$2\}\'\` >>$script
echo	nice=\`echo \$line \| awk \'\{print \$3\}\'\` >>$script
echo	system=\`echo \$line \| awk \'\{print \$4\}\'\` >>$script
echo	iowait=\`echo \$line \| awk \'\{print \$6\}\'\` >>$script
echo	irq=\`echo \$line \| awk \'\{print \$7\}\'\` >>$script
echo	softirq=\`echo \$line \| awk \'\{print \$8}\'\` >>$script
echo	sum_current=\`expr \$user \+ \$nice \+ \$system \+ \$idle \+ \$iowait \+ \$irq \+ \$softirq\` >>$script
echo	sum_difference=\`expr \$sum_current \- \$sum_previous\` >>$script
echo	sum_previous=\$sum_current >>$script
echo	echo \$hostname \$sum_difference \| nc 10\.0\.0\.1 8899 >>$script
echo	sleep 60 >>$script
echo done >>$script

escript=/etc/init.d/run_performance_monitor.sh
sudo touch $escript
sudo chown ubuntu:ubuntu $escript
chmod 700 $escript
echo \#\!\/bin\/bash > $escript
echo \# Author - Vishal Shahane >> $escript
echo \# Andrew ID - vshahane >> $escript
echo \# Email ID - vshahane\@andrew.cmu.edu >>$escript
echo \/sbin\/start-stop-daemon --start --background --oknodo --user ubuntu --name perfmon --pidfile \/var\/run\/perfmon.pid --startas $script --chuid ubuntu -- --daemon >> $escript

$escript
