#!/bin/sh
sqlfile=/var/lib/hadoop-hdfs/tweetsall.sql;
echo "add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;" > $sqlfile
echo "select user.screen_name, count(*) as n, max(user.statuses_count), max(user.followers_count), max(user.friends_count) from tweets GROUP BY user.screen_name ORDER BY n DESC LIMIT $1;" >> $sqlfile
/usr/bin/hive -S -f /var/lib/hadoop-hdfs/tweetsall.sql  > /tmp/out
echo "TwitterAccount	TweetsCount	OverallTweets	FollowersCount	FriendsCount" > /tmp/out2
cat /tmp/out | grep -v "SLF4J:" >> /tmp/out2
rm /tmp/out
