#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/timezone.sql;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
echo "SELECT user.time_zone, COUNT(*) AS total_count FROM tweets WHERE user.time_zone IS NOT NULL GROUP BY user.time_zone ORDER BY total_count DESC LIMIT $1;" >> $sqlfile
/usr/bin/hive -S -f /var/lib/hadoop-hdfs/timezone.sql  > /tmp/out
echo "TimeZone	TweetsCount" > /tmp/out2
cat /tmp/out | grep -v "SLF4J:" >> /tmp/out2
rm /tmp/out
