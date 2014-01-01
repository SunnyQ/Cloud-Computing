#!/bin/sh
#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/data-load.sql;
logfile=/var/lib/hadoop-hdfs/data-load.log;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
date1=`date --date='1 hour ago' "+%Y/%m/%d/%H"`;
date2=`date --date='1 hour ago' "+%Y%m%d%H"`;
echo "LOAD DATA INPATH '/user/flume/tweets/$date1' INTO TABLE \`default.tweets\` PARTITION (datehour='$date2');" >> $sqlfile

cat $sqlfile;
	/usr/bin/hive -S -f $sqlfile >> $logfile
