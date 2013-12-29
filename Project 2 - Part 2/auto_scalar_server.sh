##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script is management console for auto scalar
#
##################################################################
#!/bin/bash
usage() {
  echo "USAGE: autoscalar: [options]
  \"-i template name/path\" - Instantiates cluster as per given template
  \"-d\" - Destroy cluster
  \"-h\" - print this usage message
  \"-s\" - Start data collection for generating graph (Use at the start of the load)
  \"-g\" - Generate graph from data collected (Use at the end of load test)
  \"-e\" - Exit from the auto scalar server prompt"
}

trap 'kill $(jobs -pr)' SIGINT SIGTERM

echo "...............Auto Scalar Server Management Console.............."
echo 
echo
usage

while :
do
	read INPUT < /dev/tty
	if [ $INPUT = "-e" ]; then
		exit 0
	fi
	/users/vshahane/scripts/auto_scalar_top_level.sh $INPUT &
	echo
	echo
done
