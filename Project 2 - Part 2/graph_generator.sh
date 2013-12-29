##################################################################
# Name:- Vishal Shahane
# Andrew ID:- vshahane
# Email ID:- vshahane@andrew.cmu.edu
#
# This script generated the graphs using GNU plot
#
##################################################################
#!/bin/bash
echo "Generating plot for Server count"
/usr/bin/gnuplot < /users/vshahane/data/generate_plot_combine > /users/vshahane/data/plot/combined.png
/usr/bin/gnuplot < /users/vshahane/data/generate_plot_servercount > /users/vshahane/data/plot/server_count.png
/usr/bin/gnuplot < /users/vshahane/data/generate_plot_metric > /users/vshahane/data/plot/metric_used.png
/usr/bin/gnuplot < /users/vshahane/data/generate_plot_responsetime > /users/vshahane/data/plot/response_time.png
