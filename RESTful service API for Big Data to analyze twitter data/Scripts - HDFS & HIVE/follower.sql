add jar /usr/share/java/hive-serdes-1.0-SNAPSHOT.jar;
select user.screen_name, max(user.followers_count) t from tweets GROUP BY user.screen_name ORDER BY t DESC LIMIT 15;
