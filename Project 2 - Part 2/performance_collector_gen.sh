##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script generates performance collector (which collects
# performance from individual servers or VMs)
#
##################################################################
#!/bin/bash
script=/usr/local/src/performance_collector.sh
sudo touch $script
sudo chown vshahane:Ope-Group14 $script
chmod 700 $script
echo \#\!\/bin\/bash > $script
echo \# Author - Vishal Shahane >> $script
echo \# Andrew ID - vshahane >> $script
echo \# Email ID - vshahane\@andrew.cmu.edu >> $script
echo while true\; do >> $script
echo 	\/bin\/nc -l 10\.0\.0\.1 8899 \>\> \/users\/vshahane\/performance_collector\.out >> $script
echo done >> $script

escript=/etc/init.d/run_performance_collector.sh
sudo touch $escript
sudo chown vshahane:Ope-Group14 $escript
chmod 700 $escript
echo \#\!\/bin\/bash > $escript
echo \# Author - Vishal Shahane >> $escript
echo \# Andrew ID - vshahane >> $escript
echo \# Email ID - vshahane\@andrew.cmu.edu >>$escript
echo \/sbin\/start-stop-daemon --start --background --oknodo --user vshahane --name perfmon --pidfile \/var\/run\/perfmon.pid --startas $script --chuid vshahane -- --daemon >> $escript

$escript
