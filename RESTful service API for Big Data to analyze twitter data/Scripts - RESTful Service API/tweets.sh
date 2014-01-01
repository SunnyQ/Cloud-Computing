#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/tweets.sql;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
echo "select user.screen_name, count(*) as total from tweets GROUP BY user.screen_name ORDER BY total DESC LIMIT $1;" >> $sqlfile
/usr/bin/hive -S -f /var/lib/hadoop-hdfs/tweets.sql > /tmp/out
echo "TwitterAccount	TweetsCount" > /tmp/out2
cat /tmp/out | grep -v "SLF4J:" >> /tmp/out2
rm /tmp/out
