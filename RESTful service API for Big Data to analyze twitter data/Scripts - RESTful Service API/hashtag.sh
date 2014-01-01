#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/hashtag.sql;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
echo "SELECT LOWER(hashtags.text), COUNT(*) AS total_count FROM tweets LATERAL VIEW EXPLODE(entities.hashtags) t1 AS hashtags GROUP BY LOWER(hashtags.text) ORDER BY total_count DESC LIMIT $1;" >> $sqlfile
/usr/bin/hive -S -f /var/lib/hadoop-hdfs/hashtag.sql  > /tmp/out
echo "Hashtag	TweetsCount" > /tmp/out2
cat /tmp/out | grep -v "SLF4J:" >> /tmp/out2
rm /tmp/out
