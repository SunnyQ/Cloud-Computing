#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/friends.sql;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
echo "select user.screen_name, max(user.friends_count) t from tweets GROUP BY user.screen_name ORDER BY t DESC LIMIT $1;" >> $sqlfile
/usr/bin/hive -S -f /var/lib/hadoop-hdfs/friends.sql  > /tmp/out
echo "TwitterAccount	FriendsCount" > /tmp/out2
cat /tmp/out | grep -v "SLF4J:" >> /tmp/out2
rm /tmp/out
